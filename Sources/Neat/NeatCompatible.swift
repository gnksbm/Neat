import Foundation

public protocol NeatCompatible { }

extension NeatCompatible where Self: AnyObject {
    public var nt: Neat<Self> {
        Neat(self)
    }
}

extension NSObject: NeatCompatible { }
