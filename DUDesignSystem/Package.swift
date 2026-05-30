// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DUDesignSystem",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DUDesignSystem",
            targets: ["DUDesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "DUDesignSystem",
            resources: [.process("Resources")]
        ),

    ]
)
