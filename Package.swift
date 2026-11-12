// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Lumen",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Lumen", targets: ["Lumen"]),
    ],
    targets: [
        .target(
            name: "Lumen",
            resources: [.process("Shaders")]
        ),
        .testTarget(
            name: "LumenTests",
            dependencies: ["Lumen"]
        ),
    ]
)
