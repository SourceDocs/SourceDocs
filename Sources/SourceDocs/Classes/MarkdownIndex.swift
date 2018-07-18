//
//  MarkdownIndex.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/4/17.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
import MarkdownGenerator
import Rainbow

struct MarkdownOptions {
    var collapsibleBlocks: Bool
    var tableOfContents: Bool
}

class MarkdownIndex {
    var structs: [MarkdownObject] = []
    var classes: [MarkdownObject] = []
    var extensions: [MarkdownExtension] = []
    var enums: [MarkdownEnum] = []
    var protocols: [MarkdownProtocol] = []
    var typealiases: [MarkdownTypealias] = []

    func write(to docsPath: String, contentsFileName filename: String) throws {
        extensions = flattenedExtensions()

        fputs("Generating Markdown documentation...\n".green, stdout)

        let status = [protocols, structs, classes, enums, extensions, typealiases].compactMap {
            guard let documentables = $0 as? [Documentable] else {
                return nil
            }

            return documentables.reduce(DocumentationStatus()) { (result, documentable) in
                return result + documentable.checkDocumentation()
            }
            }.reduce(DocumentationStatus(), +)

        var content: [MarkdownConvertible] = [
            """
            # Reference Documentation
            This Reference Documentation has been generated with
            [SourceDocs](https://github.com/eneko/SourceDocs).

            Coverage \(Int(status.precentage * 100))%
            """
        ]

        try content.append(writeAndIndexFiles(items: protocols, to: docsPath, collectionTitle: "Protocols"))
        try content.append(writeAndIndexFiles(items: structs, to: docsPath, collectionTitle: "Structs"))
        try content.append(writeAndIndexFiles(items: classes, to: docsPath, collectionTitle: "Classes"))
        try content.append(writeAndIndexFiles(items: enums, to: docsPath, collectionTitle: "Enums"))
        try content.append(writeAndIndexFiles(items: extensions, to: docsPath, collectionTitle: "Extensions"))
        try content.append(writeAndIndexFiles(items: typealiases, to: docsPath, collectionTitle: "Typealiases"))

        try writeFile(file: MarkdownFile(filename: filename, basePath: docsPath, content: content))
        try writeFile(file: DocumentationStatusFile(basePath: docsPath, status: status))
        fputs("Done 🎉\n".green, stdout)
    }

    private func writeAndIndexFiles(items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                                    to docsPath: String, collectionTitle: String) throws -> [MarkdownConvertible] {
        if items.isEmpty {
            return []
        }

        // Make and write files
        let files = makeFiles(with: items, basePath: "\(docsPath)/\(collectionTitle)")
        try files.forEach { try writeFile(file: $0) }

        // Make links for index
        let links: [MarkdownLink] = files.map {
            let url = "\(collectionTitle)/\($0.filename)"
            return MarkdownLink(text: $0.filename, url: url)
        }
        return [
            "## \(collectionTitle)",
            MarkdownList(items: links.sorted { $0.text < $1.text })
        ]
    }

    private func writeFile(file: Writeable) throws {
        fputs("  Writing documentation file: \(file.filePath)", stdout)
        do {
            try file.write()
            fputs(" ✔\n".green, stdout)
        } catch let error {
            fputs(" ❌\n", stdout)
            throw error
        }
    }

    private func makeFiles(with items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                           basePath: String) -> [MarkdownFile] {
        return items.map { MarkdownFile(filename: $0.name, basePath: basePath, content: [$0]) }
    }

    /// While other types can only have one declaration within a Swift module,
    /// there can be multiple extensions for the same type.
    private func flattenedExtensions() -> [MarkdownExtension] {
        let extensionsByType = zip(extensions.map { $0.name }, extensions)
        let groupedByType = Dictionary(extensionsByType) { existing, new -> MarkdownExtension in
            var merged = existing
            merged.methods += new.methods
            merged.properties += new.properties
            return merged
        }
        return Array(groupedByType.values)
    }
}
