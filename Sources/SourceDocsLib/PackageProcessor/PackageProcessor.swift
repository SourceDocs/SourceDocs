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

    public init(basePath: String) {
        self.basePath = basePath
    }

    public func run() throws {
        let packageDump = try loadPackageDump()

        if GraphGenerator.canRenderDOT {
            try GraphGenerator(basePath: basePath, packageDump: packageDump).run()
        }

        let content: [MarkdownConvertible] = [
            MarkdownHeader(title: "Package: **\(packageDump.name)**"),
            renderProductsSection(from: packageDump),
            renderModulesSection(from: packageDump),
            renderPackageDependenciesSection(from: packageDump),
            renderRequirementsSection(from: packageDump),
        ]

        try MarkdownFile(filename: "Package", basePath: basePath, content: content).write()
    }

    func renderProductsSection(from packageDump: PackageDump) -> MarkdownConvertible {
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
            "List of products in \(packageDump.name) package.",
            MarkdownTable(headers: ["Product", "Type", "Targets"], data: rows),
            "_Libraries denoted 'automatic' can be both static or dynamic._",
        ]
    }

    func renderModulesSection(from packageDump: PackageDump) -> MarkdownConvertible {
        return [
            MarkdownHeader(title: "Modules", level: .h2),
            renderTargets(from: packageDump),
            MarkdownHeader(title: "Module Dependency Graph", level: .h3),
            "[![Module Dependency Graph](PackageModules.png)](PackageModules.png)",
        ]
    }

    func renderTargets(from packageDump: PackageDump) -> MarkdownConvertible {
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

    func renderPackageDependenciesSection(from packageDump: PackageDump) -> MarkdownConvertible {
        let title = MarkdownHeader(title: "Package Dependecies", level: .h2)
        if packageDump.dependencies.isEmpty {
            return [
                title,
                "This package has zero dependencies 🎉"
            ]
        }
        return [
            title,
            renderDependenciesTable(from: packageDump),
            MarkdownHeader(title: "Package Dependency Graph", level: .h3),
            "graph"
        ]
    }

    func renderDependenciesTable(from packageDump: PackageDump) -> MarkdownConvertible {
        let rows = packageDump.dependencies.map { dependency -> [String] in
            let name = dependency.name + " " + (dependency.explicitName ?? "")
            let versions = dependency.requirement.description
            return [name, versions]
        }
        return MarkdownTable(headers: ["Package", "Versions"], data: rows)
    }

    func renderRequirementsSection(from packageDump: PackageDump) -> MarkdownConvertible {
        return [
            MarkdownHeader(title: "Requirements", level: .h2),
            renderPlatforms(from: packageDump),
        ]
    }

    func renderPlatforms(from packageDump: PackageDump) -> MarkdownConvertible {
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

    func loadPackageDump() throws -> PackageDump {
        let result = try system(command: "swift package dump-package", captureOutput: true)
        print(result.standardOutput)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDump.self, from: data)
    }
}
