// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceDocs",
    products: [
        .executable(name: "sourcedocs", targets: ["SourceDocs"]),
        .library(name: "SourceDocsLib", targets: ["SourceDocsLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.26.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/eneko/MarkdownGenerator.git", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.1"),
        .package(url: "https://github.com/eneko/System.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "SourceDocsLib", dependencies: [
            "SourceKittenFramework",
            "MarkdownGenerator",
            "Rainbow",
            "Commandant",
            "Curry"
        ]),
        .target(name: "SourceDocs", dependencies: ["SourceDocsLib"]),
        .testTarget(name: "BehavioralTests", dependencies: ["System"]),
        .testTarget(name: "UnitTests", dependencies: ["SourceDocsLib"]),
        .target(name: "SourceDocsDemo", dependencies: []),
    ]
)
