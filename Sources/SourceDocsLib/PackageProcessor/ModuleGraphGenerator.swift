//
//  ModuleGraphGenerator.swift
//
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation

final class ModuleGraphGenerator: GraphGenerator {

    let basePath: URL
    let packageDump: PackageDump
    var canRenderDOT = true
    var clustersEnabled = true

    init(basePath: URL, packageDump: PackageDump) {
        self.basePath = basePath
        self.packageDump = packageDump
    }

    func run() throws {
        let graph = generateDOT(from: packageDump)

        let graphPath = basePath.appendingPathComponent("PackageModules.dot")
        fputs("  Writing \(graphPath.path)", stdout)
        try graph.write(to: graphPath, atomically: true, encoding: .utf8)
        fputs(" ✔\n".green, stdout)

        if canRenderDOT {
            let imagePath = basePath.appendingPathComponent("PackageModules.png")
            fputs("  Writing \(imagePath.path)", stdout)
            try generatePNG(input: graphPath, output: imagePath)
            fputs(" ✔\n".green, stdout)
        }
    }

    func generateDOT(from packageDump: PackageDump) -> String {
        let regularNodes = packageDump.targets.filter { $0.type != .test }.map { quoted($0.name) }
        let testNodes = packageDump.targets.filter { $0.type == .test }.map { quoted($0.name) }

        let dependencies = packageDump.targets.flatMap { $0.dependencies.map { quoted($0.label) } }
        let externalNodes = Set(dependencies).subtracting(regularNodes).subtracting(testNodes).sorted()

        let edges = packageDump.targets.flatMap { targetDescription -> [String] in
            return targetDescription.dependencies.map { dependency -> String in
                return "\(quoted(targetDescription.name)) -> \(quoted(dependency.label))"
            }
        }

        let clusters = [
            cluster(with: regularNodes, name: "Regular", label: "Program Modules", color: "#caecec"),
            cluster(with: testNodes, name: "Test", label: "Test Modules", color: "#aaccee"),
            cluster(with: externalNodes, name: "External", label: "External Dependencies", color: "#eeccaa")
        ]

        return """
        digraph ModuleDependencyGraph {
            rankdir = LR
            graph [fontname="Helvetica-light", style = filled, color = "#eaeaea"]
            node [shape=box, fontname="Helvetica", style=filled]
            edge [color="#545454"]

            \(indented: clusters.joined(separator: "\n"))

            \(indented: edges.joined(separator: "\n"))
        }
        """
    }

    func cluster(with nodes: [String], name: String, label: String, color: String) -> String {
        if nodes.isEmpty {
            return ""
        }

        let clusterPrefix = clustersEnabled ? "cluster" : ""

        return """
        subgraph \(clusterPrefix)\(name) {
            label = "\(label)"
            node [color="\(color)"]
            \(indented: nodes.joined(separator: "\n"))
        }
        """
    }

}
