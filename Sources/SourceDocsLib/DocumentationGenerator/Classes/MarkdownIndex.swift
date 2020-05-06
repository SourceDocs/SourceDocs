//
//  MarkdownIndex.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation
import MarkdownGenerator
import Rainbow

struct MarkdownOptions {
    var collapsibleBlocks: Bool
    var tableOfContents: Bool
    var minimumAccessLevel: AccessLevel
}

class MarkdownIndex {
    var structs: [MarkdownObject] = []
    var classes: [MarkdownObject] = []
    var extensions: [MarkdownExtension] = []
    var enums: [MarkdownEnum] = []
    var protocols: [MarkdownProtocol] = []
    var typealiases: [MarkdownTypealias] = []
    var methods: [MarkdownMethod] = []

    func reset() {
        structs = []
        classes = []
        extensions = []
        enums = []
        protocols = []
        typealiases = []
        methods = []
    }

    func write(to docsPath: String, linkBeginningText: String, linkEndingText: String) throws {
        extensions = flattenedExtensions()

        fputs("Generating Markdown documentation...\n".green, stdout)
        var content: [MarkdownConvertible] = [
            "# Reference Documentation"
        ]

        try content.append(writeAndIndexFiles(items: protocols, to: docsPath, collectionTitle: "Protocols",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: structs, to: docsPath, collectionTitle: "Structs",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: classes, to: docsPath, collectionTitle: "Classes",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: enums, to: docsPath, collectionTitle: "Enums",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: extensions, to: docsPath, collectionTitle: "Extensions",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: typealiases, to: docsPath, collectionTitle: "Typealiases",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))
        try content.append(writeAndIndexFiles(items: methods, to: docsPath, collectionTitle: "Methods",
                                              linkBeginningText: linkBeginningText,
                                              linkEndingText: linkEndingText))

        let footer = """
        This reference documentation was generated with
        [SourceDocs](https://github.com/eneko/SourceDocs).

        Generated at \(Date().description)
        """
        content.append(footer)

        try writeFile(file: MarkdownFile(filename: "README", basePath: docsPath, content: content))
        fputs("Done 🎉\n".green, stdout)
    }

    func writeAndIndexFiles(items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                            to docsPath: String, collectionTitle: String,
                            linkBeginningText: String,
                            linkEndingText: String) throws -> [MarkdownConvertible] {
        if items.isEmpty {
            return []
        }

        // Make and write files
        let files = makeFiles(with: items, basePath: "\(docsPath)/\(collectionTitle.lowercased())")
        try files.forEach { try writeFile(file: $0) }

        // Make links for index
        let links: [MarkdownLink] = files.map {
            let url = "\(linkBeginningText)\(collectionTitle.lowercased())/\($0.filename)\(linkEndingText)"
            return MarkdownLink(text: $0.filename, url: url)
        }
        return [
            "## \(collectionTitle)",
            MarkdownList(items: links.sorted { $0.text < $1.text })
        ]
    }

    func writeFile(file: MarkdownFile) throws {
        fputs("  Writing documentation file: \(file.filePath)", stdout)
        do {
            try file.write()
            fputs(" ✔\n".green, stdout)
        } catch let error {
            fputs(" ❌\n", stdout)
            throw error
        }
    }

    func makeFiles(with items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                   basePath: String) -> [MarkdownFile] {
        return items.map { MarkdownFile(filename: $0.name, basePath: basePath, content: [$0]) }
    }

    /// While other types can only have one declaration within a Swift module,
    /// there can be multiple extensions for the same type.
    func flattenedExtensions() -> [MarkdownExtension] {
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
