# Neat
[![Swift](https://img.shields.io/badge/Swift-5.1-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.1-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)
[![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)


Syntactic sugar for class object, especially for UIKit UI components.

## Why Use Neat?

- **Simplify Your Code:** Neat helps you quickly set up class objects by removing boilerplate code.
- **Avoid Errors:** Method chaining reduces the possibility of mistakes.
- **Improve Readability:** Chaining properties and methods enhances code readability.

## Installation

### Swift Package Manager

To integrate Neat into your project using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gnksbm/Neat.git", branch: "main")
]
```
## Usage

### Basic Usage

Initializes a UILabel with configured properties.

```swift
import Neat

let label = UILabel().nt.configure {
    $0.text("Neat")
        .font(.systemFont(ofSize: 17, weight: .semibold))
        .textColor(.black)
        .backgroundColor(.white)
}
```

This is equivalent to:

```swift
let label: UILabel = {
    let label = UILabel()
    label.text = "Neat"
    label.font = .systemFont(ofSize: 17, weight: .semibold)
    label.textColor = .black
    label.backgroundColor = .white
    return label
}()
```

### Configure Nested Value

```swift
let button = UIButton().nt.configure {
    $0.configuration(.plain())
        .configuration.image(UIImage(systemName: "circle"))
        .configuration.baseForegroundColor(.secondaryLabel)
        .layer.cornerRadius(10)
        .layer.borderWidth(1)
}
```

### Extended Commonly Used Methods

```swift
lazy var button = UIButton().nt.configure {
    $0.setTitle("Neat", for: .normal)
        .setTitleColor(.red, for: .normal)
        .setImage(UIImage(systemName: "star"), for: .normal)
        .addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
}

let tableView = UITableView().nt.configure {
    $0.register(UITableViewCell.self)
}
```

### Non-Extended Methods Usage

```swift
let view = UIView().nt.configure {
    $0.perform {
        // Perform any direct operations on the base object. 
        $0.becomeFirstResponder()
        $0.yourMethod()
    }
}
```

## License

Neat is licensed under the MIT License - see the LICENSE file for details.
