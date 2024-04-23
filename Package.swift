// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TinyHTML",
    platforms: [.iOS(.v12), .macOS(.v10_13), .visionOS(.v1), .watchOS(.v4), .tvOS(.v12)],
    products: [.library(name: "TinyHTML", targets: ["TinyHTML"])],
    targets: [
        .target(name: "TinyHTML"),
        .testTarget(name: "TinyHTMLTests", dependencies: ["TinyHTML"])
    ]
)
