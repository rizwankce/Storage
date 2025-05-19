// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftStorage",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftStorage",
            targets: ["SwiftStorage"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftStorage",
            dependencies: [],
            path: "Storage/Classes"),
        .testTarget(
            name: "SwiftStorageTests",
            dependencies: ["SwiftStorage"],
            path: "Tests"
        )
    ]
)
