//
//  DependencyGraphGenerator.swift
//
//
//  Created by Eneko Alonso on 5/7/20.
//

import Foundation

final class DependencyGraphGenerator: GraphGenerator {

    let basePath: URL
    let dependencyTree: PackageDependency
    var canRenderDOT = true
    var clustersEnabled = true

    init(basePath: URL, dependencyTree: PackageDependency) {
        self.basePath = basePath
        self.dependencyTree = dependencyTree
    }

    func run() throws {
        if dependencyTree.dependencies.isEmpty {
            return
        }

        let graph = generateDOT(from: dependencyTree)

        let graphPath = basePath.appendingPathComponent("PackageDependencies.dot")
        fputs("  Writing \(graphPath.path)", stdout)
        try graph.write(to: graphPath, atomically: true, encoding: .utf8)
        fputs(" ✔\n".green, stdout)

        if canRenderDOT {
            let imagePath = basePath.appendingPathComponent("PackageDependencies.png")
            fputs("  Writing \(imagePath.path)", stdout)
            try generatePNG(input: graphPath, output: imagePath)
            fputs(" ✔\n".green, stdout)
        }
    }

    func generateDOT(from dependencyTree: PackageDependency) -> String {
        let edges = extractEdges(from: dependencyTree)

        let clusterPrefix = clustersEnabled ? "cluster" : ""

        let graph = """
        digraph PackageDependencyGraph {
            rankdir = LR
            graph [fontname="Helvetica-light", style = filled, color = "#eaeaea"]
            node [shape=box, fontname="Helvetica", style=filled]
            edge [color="#545454"]

            subgraph \(clusterPrefix)Package {
                node [color="#caecec"]
                \(dependencyTree.nodeTitle)
            }

            subgraph \(clusterPrefix)Dependencies {
                label = "Package Dependencies"
                node [color="#eeccaa"]
                \(indented: edges.joined(separator: "\n"))
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
        let versionLabel = version == "unspecified" ? "" : "\\n\(version)"
        return """
            "\(name)\(versionLabel)"
            """
    }
}
