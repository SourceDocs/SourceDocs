// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceDocs",
    products: [
        .executable(name: "sourcedocs", targets: ["SourceDocs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.18.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
    ],
    targets: [
        .target(name: "SourceDocs", dependencies: ["SourceKittenFramework", "Rainbow"]),
        .testTarget(name: "SourceDocsTests", dependencies: ["SourceDocs"]),
    ]
)
