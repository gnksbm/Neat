import Foundation

@dynamicMemberLookup
public struct Neat<Base: AnyObject> {
    private let base: Base
    private let fileID: String
    private let line: Int
    
    init(
        _ base: Base,
        fileID: String = #fileID,
        line: Int = #line
    ) {
        self.base = base
        self.fileID = fileID
        self.line = line
    }
    
    public subscript<Property>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Base, Property>
    ) -> (Property) -> Neat<Base> {
        { newValue in
            base[keyPath: keyPath] = newValue
            return self
        }
    }
    
    public subscript<Property>(
        dynamicMember keyPath: KeyPath<Base, Property>
    ) -> PropertyNeat<Base, Property> {
        PropertyNeat(base, keyPath: keyPath)
    }
    
    public subscript<Property>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Base, Property?>
    ) -> OptionalPropertyNeat<Base, Property> {
        OptionalPropertyNeat(
            base,
            keyPath: keyPath,
            fileID: fileID,
            line: line
        )
    }
    
    public func configure(
        _ block: (Neat<Base>) -> Neat<Base>,
        fileID: @autoclosure @escaping () -> String = #fileID,
        line: @autoclosure @escaping () -> Int = #line
    ) -> Base {
        block(Neat(base, fileID: fileID(), line: line())).finalize()
    }
    
    public func perform(_ block: (Base) -> Void) -> Neat<Base> {
        block(base)
        return self
    }
    
    private func finalize() -> Base {
        base
    }
}

@dynamicMemberLookup
public struct PropertyNeat<Parent: AnyObject, Property> {
    private var parent: Parent
    private var keyPath: KeyPath<Parent, Property>
    
    init(_ parent: Parent, keyPath: KeyPath<Parent, Property>) {
        self.parent = parent
        self.keyPath = keyPath
    }
    
    public subscript<NestedProperty>(
        dynamicMember nestedKeyPath:
        ReferenceWritableKeyPath<Property, NestedProperty>
    ) -> (NestedProperty) -> Neat<Parent> {
        { newValue in
            parent[keyPath: keyPath.appending(path: nestedKeyPath)] = newValue
            return Neat(parent)
        }
    }
}

@dynamicMemberLookup
public struct OptionalPropertyNeat<Parent: AnyObject, Property> {
    private var parent: Parent
    private var keyPath: ReferenceWritableKeyPath<Parent, Property?>
    
    private let fileID: String
    private let line: Int
    
    init(
        _ parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, Property?>,
        fileID: String,
        line: Int
    ) {
        self.parent = parent
        self.keyPath = keyPath
        self.fileID = fileID
        self.line = line
    }
    
    public subscript<NestedProperty>(
        dynamicMember nestedKeyPath:
        WritableKeyPath<Property, NestedProperty>
    ) -> (NestedProperty) -> Neat<Parent> {
        { newValue in
            guard var copy = parent[keyPath: keyPath] else {
                failureLog(nestedKeyPath: nestedKeyPath)
                return Neat(parent, fileID: fileID, line: line)
            }
            copy[keyPath: nestedKeyPath] = newValue
            parent[keyPath: keyPath] = copy
            return Neat(parent, fileID: fileID, line: line)
        }
    }
    
    private func failureLog<NestedProperty>(
        nestedKeyPath: WritableKeyPath<Property, NestedProperty>
    ) {
        let parentType = String(describing: Parent.self)
        let propertyType = removingOptionalDescription(
            type: type(of: keyPath).valueType
        )
        let nestedPropertyType = removingOptionalDescription(
            type: type(of: nestedKeyPath).valueType
        )
        print(
            """
            [Neat: Failed to Update \(nestedPropertyType)]
            Location: \(fileID) at line \(line).
            \(parentType)'s \(propertyType) is nil.
            """
        )

    }
    
    private func removingOptionalDescription(type: Any.Type) -> String {
        String(describing: type)
            .replacingOccurrences(of: "Optional<", with: "")
            .replacingOccurrences(of: ">", with: "")
    }
}

#if canImport(UIKit)
import UIKit
public extension Neat where Base: UIView {
    func addSubview(view: UIView) -> Neat<Base> {
        base.addSubview(view)
        return self
    }
    
    func setContentHuggingPriority(
        _ priority: UILayoutPriority,
        for axis: NSLayoutConstraint.Axis
    ) -> Neat<Base> {
        base.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    func setContentCompressionResistancePriority(
        _ priority: UILayoutPriority,
        for axis: NSLayoutConstraint.Axis
    ) -> Neat<Base> {
        base.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

public extension Neat where Base: UIControl {
    func addTarget(
        _ target: Any?,
        action: Selector,
        for controlEvents: UIControl.Event
    ) -> Neat<Base> {
        base.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    func removeTarget(
        _ target: Any?,
        action: Selector?,
        for controlEvents: UIControl.Event
    ) -> Neat<Base> {
        base.removeTarget(target, action: action, for: controlEvents)
        return self
    }
}

public extension Neat where Base: UIButton {
    func setImage(
        _ image: UIImage?,
        for state: UIControl.State
    ) -> Neat<Base> {
        base.setImage(image, for: state)
        return self
    }
    
    func setTitle(
        _ title: String?,
        for state: UIControl.State
    ) -> Neat<Base> {
        base.setTitle(title, for: state)
        return self
    }
    
    func setTitleColor(
        _ color: UIColor?,
        for state: UIControl.State
    ) -> Neat<Base> {
        base.setTitleColor(color, for: state)
        return self
    }
}

public extension Neat where Base: UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) -> Neat<Base> {
        base.register(
            cellClass,
            forCellReuseIdentifier: String(describing: T.self)
        )
        return self
    }
}

public extension Neat where Base: UICollectionView {
    func register<T: UICollectionViewCell>(
        _ cellClass: T.Type
    ) -> Neat<Base> {
        base.register(
            cellClass,
            forCellWithReuseIdentifier: String(describing: T.self)
        )
        return self
    }
}

public extension Neat where Base: UIAlertController {
    func addAction(_ action: UIAlertAction) -> Neat<Base> {
        base.addAction(action)
        return self
    }
}

public extension Neat where Base: UIActivityIndicatorView {
    func startAnimating() -> Neat<Base> {
        base.startAnimating()
        return self
    }
    
    func stopAnimating() -> Neat<Base> {
        base.stopAnimating()
        return self
    }
}

public extension Neat where Base: NSMutableAttributedString {
    func append(_ attrString: NSAttributedString) -> Neat<Base> {
        base.append(attrString)
        return self
    }
}

@available(iOS 13.0, *)
public extension Neat where Base: UINavigationBarAppearance {
    func configureWithOpaqueBackground() -> Neat<Base> {
        base.configureWithOpaqueBackground()
        return self
    }
}

@available(iOS 13.0, *)
public extension Neat where Base: UITabBarAppearance {
    func configureWithOpaqueBackground() -> Neat<Base> {
        base.configureWithOpaqueBackground()
        return self
    }
}
#endif
