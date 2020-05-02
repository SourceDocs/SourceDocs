// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SourceDocs",
    products: [
        .executable(name: "sourcedocs", targets: ["SourceDocsCLI"]),
        .library(name: "SourceDocsLib", targets: ["SourceDocsLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
//        .package(name: "SwiftPM", url: "https://github.com/apple/swift-package-manager", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-package-manager", from: "0.0.1"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.29.0"),
        .package(url: "https://github.com/eneko/MarkdownGenerator.git", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/eneko/System.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "SourceDocsCLI", dependencies: [
            "SourceDocsLib",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Rainbow"
        ]),
        .target(name: "SourceDocsLib", dependencies: [
            .product(name: "SourceKittenFramework", package: "SourceKitten"),
            "MarkdownGenerator",
            "Rainbow",
            "System",
            "SwiftPM",
        ]),
        .target(name: "SourceDocsDemo", dependencies: []),
        .testTarget(name: "SourceDocsCLITests", dependencies: ["System"]),
        .testTarget(name: "SourceDocsLibTests", dependencies: ["SourceDocsLib"])
    ]
)
