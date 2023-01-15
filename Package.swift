// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FAFoundation",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "FAFoundation",
            targets: ["FAFoundation"]),
    ],
    targets: [
        .target(
            name: "FAFoundation",
            dependencies: []),
        .testTarget(
            name: "FAFoundationTests",
            dependencies: ["FAFoundation"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
