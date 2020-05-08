//
//  ModuleGraphGenerator.swift
//  
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation

final class ModuleGraphGenerator: GraphGenerator {

    let basePath: String
    let packageDump: PackageDump

    init(basePath: String, packageDump: PackageDump) {
        self.basePath = basePath
        self.packageDump = packageDump
    }

    func run() throws {
        let graph = generateDOT(from: packageDump)
        let graphPath = URL(fileURLWithPath: basePath).appendingPathComponent("PackageModules.dot")
        fputs("  Writing \(graphPath.path)", stdout)
        try graph.write(to: graphPath, atomically: true, encoding: .utf8)
        fputs(" ✔\n".green, stdout)
        let imagePath = URL(fileURLWithPath: basePath).appendingPathComponent("PackageModules.png")
        fputs("  Writing \(imagePath.path)", stdout)
        try generatePNG(input: graphPath, output: imagePath)
        fputs(" ✔\n".green, stdout)
    }

    func generateDOT(from packageDump: PackageDump) -> String {
        let regularNodes = packageDump.targets.filter { $0.type != .test }.map { quoted($0.name) }
        let testNodes = packageDump.targets.filter { $0.type == .test }.map { quoted($0.name) }

        let dependencies = packageDump.targets.flatMap { $0.dependencies.map { quoted($0.name) } }
        let externalNodes = Set(dependencies).subtracting(regularNodes).subtracting(testNodes).sorted()

        let edges = packageDump.targets.flatMap { targetDescription -> [String] in
            return targetDescription.dependencies.map { dependency -> String in
                return "\(quoted(targetDescription.name)) -> \(quoted(dependency.name))"
            }
        }

        let regularNodeCluster = regularNodes.isEmpty ? "" : """
        subgraph clusterRegular {
            label = "Regular Modules"
            node [color="#caecec"]
            \(regularNodes.joined(separator: "\n    "))
        }
        """

        let testNodeCluster = testNodes.isEmpty ? "" : """
        subgraph clusterTests {
            label = "Test Modules"
            node [color="#aaccee"]
            \(testNodes.joined(separator: "\n    "))
        }
        """

        let externalNodeCluster = externalNodes.isEmpty ? "" : """
        subgraph clusterExternal {
            label = "External Dependencies"
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

}
