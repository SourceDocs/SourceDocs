//
//  PackageProcessor.swift
//  
//
//  Created by Eneko Alonso on 5/1/20.
//

import Foundation
import System
import MarkdownGenerator

public final class PackageProcessor {
    let basePath: String
    let canRenderDOT: Bool
    let packageDump: PackageDump
    let packageDependencies: PackageDependency

    public init(basePath: String) throws {
        self.basePath = basePath
        self.canRenderDOT = ModuleGraphGenerator.canRenderDOT
        self.packageDump = try PackageLoader.loadPackageDump()
        self.packageDependencies = try PackageLoader.loadPackageDependencies()
    }

    public func run() throws {
        if canRenderDOT {
            try ModuleGraphGenerator(basePath: basePath, packageDump: packageDump).run()
        }

        let content: [MarkdownConvertible] = [
            MarkdownHeader(title: "Package: **\(packageDump.name)**"),
            renderProductsSection(),
            renderModulesSection(),
            renderExternalDependenciesSection(),
            renderRequirementsSection(),
        ]

        try MarkdownFile(filename: "Package", basePath: basePath, content: content).write()
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
            "_Libraries denoted 'automatic' can be both static or dynamic._",
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
        guard canRenderDOT else {
            return ""
        }
        return [
            MarkdownHeader(title: "Module Dependency Graph", level: .h3),
            "[![Module Dependency Graph](PackageModules.png)](PackageModules.png)",
        ]
    }

    func renderTargets() -> MarkdownConvertible {
        let rows = packageDump.targets.map { targetDescription -> [String] in
            let name = targetDescription.name
            let type = targetDescription.type.rawValue.capitalized
            let dependencies = targetDescription.dependencies.map { $0.name }.sorted()
            return [name, type, dependencies.joined(separator: ", ")]
        }
        let regularRows = rows.filter { $0[1] != "Test" }
        let testRows = rows.filter { $0[1] == "Test" }
        return [
            MarkdownHeader(title: "Program Modules", level: .h3),
            MarkdownTable(headers: ["Module", "Type", "Dependencies"], data: regularRows),
            MarkdownHeader(title: "Test Modules", level: .h3),
            MarkdownTable(headers: ["Module", "Type", "Dependencies"], data: testRows),
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
            renderDependencyTree(dependency: packageDependencies),
            MarkdownHeader(title: "Package Dependency Graph", level: .h3),
            renderExternalDependenciesGraph()
        ]
    }

    func renderDependenciesTable() -> MarkdownConvertible {
        let sortedDependencies = packageDump.dependencies.sorted { $0.name < $1.name }
        let rows = sortedDependencies.map { dependency -> [String] in
            let name = MarkdownLink(text: dependency.name, url: dependency.url).markdown
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

//    func renderDependencyTree(dependencies: [PackageDependency]) -> MarkdownConvertible {
//        if dependencies.isEmpty {
//            return []
//        }
//        let items = dependencies.map { dependency -> MarkdownConvertible in
//            let link = MarkdownLink(text: "\(dependency.name) (\(dependency.version))", url: dependency.url)
//            return [link] + renderDependencyTree(dependencies: dependency.dependencies)
//        }
//        return MarkdownList(items: items)
//    }

    func renderExternalDependenciesGraph() -> MarkdownConvertible {
        guard canRenderDOT else {
            return ""
        }
        return "aaa"
    }

    func renderRequirementsSection() -> MarkdownConvertible {
        return [
            MarkdownHeader(title: "Requirements", level: .h2),
            renderPlatforms(),
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
            MarkdownTable(headers: ["Platform", "Version"], data: rows),
        ]
    }
}
