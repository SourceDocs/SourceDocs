//
//  PackageProcessor.swift
//  
//
//  Created by Eneko Alonso on 5/1/20.
//

import Foundation
import PackageModel
//import PackageLoading
//import PackageGraph
//import Workspace
import System
import MarkdownGenerator

public final class PackageProcessor {

    let path: String

    public init(path: String) {
        self.path = path
    }

    public func run() throws {
        let packageDump = try loadPackageDump()

        if let dot = try whichDot() {
            let graph = renderTargetGraph(from: packageDump)
            let graphPath = URL(fileURLWithPath: "PackageModules.dot")
            try graph.write(to: graphPath, atomically: true, encoding: .utf8)
            let imagePath = URL(fileURLWithPath: "PackageModules.png")
            try generateGraphPNG(dot: dot, input: graphPath, output: imagePath)
        }

        let content: [MarkdownConvertible] = [
            MarkdownHeader(title: "Package: " + packageDump.name),
            MarkdownHeader(title: "Products", level: .h2),
            renderProducts(from: packageDump),
            MarkdownHeader(title: "Modules", level: .h2),
            renderTargets(from: packageDump),
            MarkdownHeader(title: "Module Dependency Graph", level: .h3),
            MarkdownImage(url: "PackageModules.png"),
            MarkdownHeader(title: "Package Dependecies", level: .h2),
            MarkdownHeader(title: "Package Dependency Graph", level: .h3),
        ]

        try MarkdownFile(filename: "Package", content: content).write()
    }

    func loadPackageDump() throws -> PackageDump {
        let result = try system(command: "swift package dump-package", captureOutput: true)
        print(result.standardOutput)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDump.self, from: data)
    }

    func renderProducts(from packageDump: PackageDump) -> MarkdownConvertible {
        let rows = packageDump.products.map { productDescription -> [String] in
            let name = productDescription.name
            let type = productDescription.type.label
            let targets = productDescription.targets
            return [name, type, targets.joined(separator: ", ")]
        }
        return [
            MarkdownTable(headers: ["Product", "Type", "Targets"], data: rows),
        ]
    }

    func renderTargets(from packageDump: PackageDump) -> MarkdownConvertible {
        let rows = packageDump.targets.map { targetDescription -> [String] in
            let name = targetDescription.name
            let type = targetDescription.type.rawValue
            let dependencies = targetDescription.dependencies.map { $0.name }
            return [name, type, dependencies.joined(separator: ", ")]
        }
        return [
            MarkdownTable(headers: ["Module", "Type", "Dependencies"], data: rows),
        ]
    }

    func renderTargetGraph(from packageDump: PackageDump) -> String {
        let regularNodes = packageDump.targets.filter { $0.type != .test }.map { $0.name }
        let testNodes = packageDump.targets.filter { $0.type == .test }.map { $0.name }

        let dependencies = packageDump.targets.flatMap { $0.dependencies.map { $0.name } }
        let externalNodes = Set(dependencies).subtracting(regularNodes).subtracting(testNodes)

        let edges = packageDump.targets.flatMap { targetDescription -> [String] in
            return targetDescription.dependencies.map { dependency -> String in
                return "\(targetDescription.name) -> \(dependency.name)"
            }
        }

        let regularNodeCluster = regularNodes.isEmpty ? "" : """
        subgraph clusterRegular {
            label = "Targets"
            node [color="#caecec"]
            \(regularNodes.joined(separator: "\n    "))
        }
        """

        let testNodeCluster = testNodes.isEmpty ? "" : """
        subgraph clusterTests {
            label = "Tests"
            node [color="#aaccee"]
            \(testNodes.joined(separator: "\n    "))
        }
        """

        let externalNodeCluster = externalNodes.isEmpty ? "" : """
        subgraph clusterExternal {
            label = "Dependencies"
            node [color="#fafafa"]
            \(externalNodes.joined(separator: "\n    "))
        }
        """

        let graph = """
            digraph ModuleDependencyGraph {
                rankdir = LR
                graph [fontname="Helvetica-light", style = filled, color = "#eaeaea"]
                node [shape=box, fontname="Helvetica", style=filled]
                edge [color="#545454"]

                \(regularNodeCluster)
                \(testNodeCluster)
                \(externalNodeCluster)

                \(edges.joined(separator: "\n    "))
            }
            """

        return graph
    }

    func generateGraphPNG(dot: String, input: URL, output: URL) throws {
        try system(command: dot, "-Tpng", input.path, "-o", output.path)
    }

    func whichDot() throws -> String? {
        let result = try system(command: "/usr/bin/which dot", captureOutput: true)
        guard result.standardOutput.isEmpty == false else {
            return nil
        }
        return result.standardOutput
    }

    // Package load

//    public func run() throws {
//        let packagePath = AbsolutePath(path)
//        dump(packagePath)
//        let swiftCompiler = try self.swiftCompiler()
//        let binDir = swiftCompiler.parentDirectory
//        let libDir = binDir.parentDirectory.appending(components: "lib", "swift", "pm")
//        let resources = UserManifestResources(swiftCompiler: swiftCompiler, libDir: libDir)
//        dump(resources)
//        let loader = ManifestLoader(manifestResources: resources)
//        let toolsVersion = try ToolsVersionLoader().load(at: packagePath, fileSystem: localFileSystem)
//        dump(toolsVersion)
//        let manifest = try loader.load(package: packagePath, baseURL: packagePath.pathString,
//                                       manifestVersion: toolsVersion.manifestVersion)
//        dump(manifest)
//    }
//
//    func swiftCompiler() throws -> AbsolutePath {
//        let string: String
//        #if os(macOS)
//        string = try Process.checkNonZeroExit(args: "xcrun", "--sdk", "macosx", "-f", "swiftc").spm_chomp()
//        #else
//        string = try Process.checkNonZeroExit(args: "which", "swiftc").spm_chomp()
//        #endif
//        return AbsolutePath(string)
//    }
}

struct PackageDump: Codable {
    let name: String
    let products: [ProductDescription]
    let targets: [TargetDescription]
    let dependencies: [PackageDependencyDescription]
}

extension ProductType {
    static let frameworkImage = "💼"
    static let libraryImage = "🏛"
    static let binaryImage = "🏎"

    var label: String {
        switch description {
        case "automatic":
            return "\(Self.frameworkImage) Library (automatic)"
        case "dynamic":
            return "\(Self.frameworkImage) Library (dynamic)"
        case "static":
            return "\(Self.libraryImage) Library (static)"
        case "executable":
            return "\(Self.binaryImage) Executable"
        default:
            return description.capitalized
        }
    }
}
extension TargetDescription.Dependency {
    var name: String {
        switch self {
        case let .byName(name):
            return name
        case let .product(name, _):
            return name
        case let .target(name):
            return name
        }
    }
}
