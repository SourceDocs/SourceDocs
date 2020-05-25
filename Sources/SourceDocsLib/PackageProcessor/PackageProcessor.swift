//
//  PackageProcessor.swift
//
//
//  Created by Eneko Alonso on 5/1/20.
//

import Foundation
import Rainbow
import System
import MarkdownGenerator

public final class PackageProcessor {
    let inputPath: URL
    let outputPath: URL
    let reproducibleDocs: Bool
    let canRenderDOT: Bool
    let packageDump: PackageDump
    let packageDependencyTree: PackageDependency

    public enum Error: Swift.Error {
        case invalidInput
    }

    static var canRenderDOT: Bool {
        let result = try? system(command: "which dot", captureOutput: true)
        return result?.standardOutput.isEmpty == false
    }

    public init(inputPath: String, outputPath: String, reproducibleDocs: Bool) throws {
        self.inputPath = URL(fileURLWithPath: inputPath)
        self.outputPath = URL(fileURLWithPath: outputPath)
        self.reproducibleDocs = reproducibleDocs
        canRenderDOT = Self.canRenderDOT

        let path = self.inputPath.appendingPathComponent("Package.swift").path
        guard FileManager.default.fileExists(atPath: path) else {
            throw Error.invalidInput
        }

        try PackageLoader.resolveDependencies(at: inputPath)
        packageDump = try PackageLoader.loadPackageDump(from: inputPath)
        packageDependencyTree = try PackageLoader.loadPackageDependencies(from: inputPath)
    }

    public func run() throws {
        fputs("Processing package...\n".green, stdout)
        try createOutputFolderIfNeeded()
        try ModuleGraphGenerator(basePath: outputPath, packageDump: packageDump,
                                 canRenderDOT: canRenderDOT).run()
        try DependencyGraphGenerator(basePath: outputPath, dependencyTree: packageDependencyTree,
                                     canRenderDOT: canRenderDOT).run()

        let content: [MarkdownConvertible] = [
            MarkdownHeader(title: "Package: **\(packageDump.name)**"),
            renderProductsSection(),
            renderModulesSection(),
            renderExternalDependenciesSection(),
            renderRequirementsSection(),
            DocumentationGenerator.generateFooter(reproducibleDocs: reproducibleDocs)
        ]

        let file = MarkdownFile(filename: "Package", basePath: outputPath.path, content: content)
        fputs("  Writing \(file.filePath)", stdout)
        try file.write()
        fputs(" ✔\n".green, stdout)
        fputs("Done 🎉\n".green, stdout)
    }

    func createOutputFolderIfNeeded() throws {
        if FileManager.default.fileExists(atPath: outputPath.path) {
            return
        }
        try FileManager.default.createDirectory(at: outputPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }

    func renderProductsSection() -> MarkdownConvertible {
        if packageDump.products.isEmpty {
            return ""
        }
        let rows = packageDump.products.map { productDescription -> [String] in
            let name = productDescription.name
            let type = productDescription.type.label
            let targets = productDescription.targets
            return [name, type, targets.joined(separator: ", ")]
        }
        return [
            MarkdownHeader(title: "Products", level: .h2),
            "List of products in this package:",
            MarkdownTable(headers: ["Product", "Type", "Targets"], data: rows),
            "_Libraries denoted 'automatic' can be both static or dynamic._"
        ]
    }

    func renderModulesSection() -> MarkdownConvertible {
        return [
            MarkdownHeader(title: "Modules", level: .h2),
            renderTargets(),
            renderModuleGraph()
        ]
    }

    func renderModuleGraph() -> MarkdownConvertible {
        let url = outputPath.appendingPathComponent("PackageModules.png")
        guard FileManager.default.fileExists(atPath: url.path) else {
            return ""
        }
        return [
            MarkdownHeader(title: "Module Dependency Graph", level: .h3),
            "[![Module Dependency Graph](PackageModules.png)](PackageModules.png)"
        ]
    }

    func renderTargets() -> MarkdownConvertible {
        let rows = packageDump.targets.map { targetDescription -> [String] in
            let name = targetDescription.name
            let type = targetDescription.type.rawValue.capitalized
            let dependencies = targetDescription.dependencies.map { $0.label }.sorted()
            return [name, type, dependencies.joined(separator: ", ")]
        }
        let regularRows = rows.filter { $0[1] != "Test" }
        let testRows = rows.filter { $0[1] == "Test" }
        return [
            MarkdownHeader(title: "Program Modules", level: .h3),
            MarkdownTable(headers: ["Module", "Type", "Dependencies"], data: regularRows),
            MarkdownHeader(title: "Test Modules", level: .h3),
            MarkdownTable(headers: ["Module", "Type", "Dependencies"], data: testRows)
        ]
    }

    func renderExternalDependenciesSection() -> MarkdownConvertible {
        let title = MarkdownHeader(title: "External Dependencies", level: .h2)
        if packageDump.dependencies.isEmpty {
            return [
                title,
                "This package has zero dependencies 🎉"
            ]
        }
        return [
            title,
            MarkdownHeader(title: "Direct Dependencies", level: .h3),
            renderDependenciesTable(),
            MarkdownHeader(title: "Resolved Dependencies", level: .h3),
            renderDependencyTree(dependency: packageDependencyTree),
            renderExternalDependenciesGraph()
        ]
    }

    func renderDependenciesTable() -> MarkdownConvertible {
        let sortedDependencies = packageDump.dependencies.sorted { $0.label < $1.label }
        let rows = sortedDependencies.map { dependency -> [String] in
            let name = MarkdownLink(text: dependency.label, url: dependency.url).markdown
            let versions = dependency.requirement.description
            return [name, versions]
        }
        return MarkdownTable(headers: ["Package", "Versions"], data: rows)
    }

    func renderDependencyTree(dependency: PackageDependency) -> MarkdownConvertible {
        let versionedName = "\(dependency.name) (\(dependency.version))"
        let link: MarkdownConvertible = dependency.url.hasPrefix("http")
            ? MarkdownLink(text: versionedName, url: dependency.url)
            : versionedName
        let items = [link] + dependency.dependencies.map(renderDependencyTree)
        return MarkdownList(items: items)
    }

    func renderExternalDependenciesGraph() -> MarkdownConvertible {
        guard canRenderDOT else {
            return ""
        }
        return [
            MarkdownHeader(title: "Package Dependency Graph", level: .h3),
            "[![Package Dependency Graph](PackageDependencies.png)](PackageDependencies.png)"
        ]
    }

    func renderRequirementsSection() -> MarkdownConvertible {
        return [
            MarkdownHeader(title: "Requirements", level: .h2),
            renderPlatforms()
        ]
    }

    func renderPlatforms() -> MarkdownConvertible {
        if packageDump.platforms.isEmpty {
            return ""
        }
        let rows = packageDump.platforms.map { platform -> [String] in
            let name = platform.platformName.replacingOccurrences(of: "os", with: "OS")
            let version = platform.version ?? ""
            return [name, version]
        }
        return [
            MarkdownHeader(title: "Minimum Required Versions", level: .h3),
            MarkdownTable(headers: ["Platform", "Version"], data: rows)
        ]
    }
}
