// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PuzzleCoding",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11)],
    products: [
        .library(name: "PuzzleCoding", targets: ["PuzzleCoding"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: "PuzzleCoding",
            swiftSettings: [
                .enableUpcomingFeature("MemberImportVisibility"),
                .enableUpcomingFeature("InternalImportsByDefault"),
            ]),
        .testTarget(name: "PuzzleCodingTests", dependencies: ["PuzzleCoding"]),
    ],
    swiftLanguageModes: [.v6]
)
