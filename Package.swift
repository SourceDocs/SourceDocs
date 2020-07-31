// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SourceDocs",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "sourcedocs", targets: ["SourceDocsCLI"]),
        .library(name: "SourceDocsLib", targets: ["SourceDocsLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-package-manager", .exact("0.4.0")),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.29.0"),
        .package(url: "https://github.com/eneko/MarkdownGenerator.git", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/eneko/ProcessRunner.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(name: "SourceDocsCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "SourceDocsLib",
            "Rainbow"
        ]),
        .target(name: "SourceDocsLib", dependencies: [
            .product(name: "SourceKittenFramework", package: "SourceKitten"),
            "SwiftPM-auto",
            "MarkdownGenerator",
            "Rainbow",
            "ProcessRunner"
        ]),
        .target(name: "SourceDocsDemo", dependencies: []),
        .testTarget(name: "SourceDocsCLITests", dependencies: ["ProcessRunner"]),
        .testTarget(name: "SourceDocsLibTests", dependencies: ["SourceDocsLib"])
    ]
)
