// swift-tools-version:5.1
import PackageDescription

#if swift(>=5.2)
let swiftPMPackage: Package.Dependency = .package(url: "https://github.com/apple/swift-package-manager",
                                                  .branch("master"))
let swiftPMModule: Target.Dependency = .product(name: "SwiftPM-auto", package: "SwiftPM")
#else
let swiftPMPackage: Package.Dependency = .package(url: "https://github.com/apple/swift-package-manager",
                                                  from: "0.1.0")
let swiftPMModule: Target.Dependency = "SwiftPM"
#endif

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
        swiftPMPackage,
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.29.0"),
        .package(url: "https://github.com/eneko/MarkdownGenerator.git", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/eneko/System.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SourceDocsCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "SourceDocsLib",
            "Rainbow"
        ]),
        .target(name: "SourceDocsLib", dependencies: [
            .product(name: "SourceKittenFramework", package: "SourceKitten"),
            swiftPMModule,
            "MarkdownGenerator",
            "Rainbow",
            "System"
        ]),
        .target(name: "SourceDocsDemo", dependencies: []),
        .testTarget(name: "SourceDocsCLITests", dependencies: ["System"]),
        .testTarget(name: "SourceDocsLibTests", dependencies: ["SourceDocsLib"])
    ]
)
