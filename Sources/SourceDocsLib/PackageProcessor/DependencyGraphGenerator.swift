//
//  DependencyGraphGenerator.swift
//  
//
//  Created by Eneko Alonso on 5/7/20.
//

import Foundation

final class DependencyGraphGenerator: GraphGenerator {

    let basePath: String
    let dependencyTree: PackageDependency

    init(basePath: String, dependencyTree: PackageDependency) {
        self.basePath = basePath
        self.dependencyTree = dependencyTree
    }

    func run() throws {
        if dependencyTree.dependencies.isEmpty {
            return
        }

        let graph = generateDOT(from: dependencyTree)
        let graphPath = URL(fileURLWithPath: basePath).appendingPathComponent("PackageDependencies.dot")
        fputs("  Writing \(graphPath.path)", stdout)
        try graph.write(to: graphPath, atomically: true, encoding: .utf8)
        fputs(" ✔\n".green, stdout)
        let imagePath = URL(fileURLWithPath: basePath).appendingPathComponent("PackageDependencies.png")
        fputs("  Writing \(imagePath.path)", stdout)
        try generatePNG(input: graphPath, output: imagePath)
        fputs(" ✔\n".green, stdout)
    }

    func generateDOT(from dependencyTree: PackageDependency) -> String {
        let edges = extractEdges(from: dependencyTree)

        let graph = """
            digraph PackageDependencyGraph {
                rankdir = LR
                graph [fontname="Helvetica-light", style = filled, color = "#eaeaea"]
                node [shape=box, fontname="Helvetica", style=filled, color="#fafafa"]
                edge [color="#545454"]

                subgraph cluster {
                    label = "Package Dependencies"
                    \(edges.joined(separator: "\n        "))
                }
            }
            """

        return graph
    }

    func extractEdges(from dependencyTree: PackageDependency) -> [String] {
        let edges = dependencyTree.dependencies.map { dependency in
            "\(dependencyTree.nodeTitle) -> \(dependency.nodeTitle)"
        }
        return edges + dependencyTree.dependencies.flatMap(extractEdges)
    }
}

extension PackageDependency {
    var nodeTitle: String {
        return "\"\(name)\\n\(version)\""
    }
}
