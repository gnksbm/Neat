// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Neat",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "Neat", targets: ["Neat"]),
        .library(name: "Neat-Dynamic", type: .dynamic, targets: ["Neat"])
    ],
    targets: [
        .target(name: "Neat")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
