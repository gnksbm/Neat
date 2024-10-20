// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Neat",
    products: [
        .library(name: "Neat", targets: ["Neat"]),
        .library(name: "Neat-Dynamic", type: .dynamic, targets: ["Neat"])
    ],
    targets: [
        .target(name: "Neat")
    ],
    swiftLanguageVersions: [
        .v4_2
    ]
)
