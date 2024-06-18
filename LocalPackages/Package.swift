// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalPackages",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "StarWarsAPI", targets: ["StarWarsAPI"]),
        .library(name: "App", targets: ["App"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StarWarsAPI",
            resources: [
                .copy("FakeResponses/")
            ]),
        .testTarget(
            name: "StarWarsAPITests",
            dependencies: ["StarWarsAPI"]),
        .target(
            name: "DesignSystem",
            resources: [
                .process("Colors/Colors.xcassets")
            ]
        ),
        .target(
            name: "App",
            dependencies: ["StarWarsAPI", "DesignSystem"],
            swiftSettings: [
                /// `targeted` or `complete`.
                .enableExperimentalFeature("StrictConcurrency=complete")
            ]),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]),
    ]
)
