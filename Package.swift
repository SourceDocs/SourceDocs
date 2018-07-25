// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceDocs",
    products: [
        .executable(name: "sourcedocs", targets: ["SourceDocs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jhildensperger/SourceKitten.git", .branch("fix/comments")),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
        .package(url: "https://github.com/eneko/MarkdownGenerator.git", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.1"),
    ],
    targets: [
        .target(name: "SourceDocs", dependencies: [
            "SourceKittenFramework",
            "MarkdownGenerator",
            "Rainbow",
            "Commandant",
            "Curry"
            ]),
        .testTarget(name: "SourceDocsTests", dependencies: ["SourceDocs"]),
        .target(name: "SourceDocsDemo", dependencies: []),
    ]
)
