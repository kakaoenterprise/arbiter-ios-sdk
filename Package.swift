// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Arbiter",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Arbiter", targets: ["Arbiter"]),
    ],

    dependencies: [],
    
    targets: [
        .binaryTarget(name: "Arbiter", path: "./Sources/Arbiter.xcframework"),
        .testTarget(
            name: "ArbiterTests",
            dependencies: ["Arbiter"]),
    ]
)
