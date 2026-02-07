// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "farm-simulation",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/STREGAsGate/Raylib.git", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "farm-simulation",
            dependencies: [
                .product(name: "Raylib", package: "Raylib")
            ]
        ),
    ]
)
