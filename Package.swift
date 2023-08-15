// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "ReadableTest",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ReadableTest",
            targets: ["ReadableTest"]),
    ],
    targets: [
        .target(
            name: "ReadableTest"),
        .testTarget(
            name: "ReadableTestTests",
            dependencies: ["ReadableTest"]),
    ]
)
