//
//  MarkdownEnum.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownEnum: SwiftDocDictionaryInitializable, MarkdownConvertible, Documentable {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    let cases: [MarkdownEnumCaseElement]
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions) {
        guard dictionary.hasPublicACL && dictionary.isKind([.enum]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            cases = structure.compactMap {
                guard let substructure: [SwiftDocDictionary] = $0.get(.substructure),
                    let first = substructure.first else {
                        return nil
                }
                return MarkdownEnumCaseElement(dictionary: first)
            }
            properties = structure.compactMap { MarkdownVariable(dictionary: $0, options: options) }
            methods = structure.compactMap { MarkdownMethod(dictionary: $0, options: options) }
        } else {
            cases = []
            properties = []
            methods = []
        }
    }

    var tableOfContents: String {
        var tableOfContents: [String] = []

        let casesToc = self.cases.map { "  - `\($0.name)`" }.joined(separator: "\n")
        if casesToc.isEmpty == false {
            tableOfContents.append("- [Cases](#cases)")
            tableOfContents.append(casesToc)
        }

        let propertyToc = self.properties.map { "  - `\($0.name)`" }.joined(separator: "\n")
        if propertyToc.isEmpty == false {
            tableOfContents.append("- [Properties](#properties)")
            tableOfContents.append(propertyToc)
        }

        let methodToc = self.methods.map { "  - `\($0.name)`" }.joined(separator: "\n")
        if methodToc.isEmpty == false {
            tableOfContents.append("- [Methods](#methods)")
            tableOfContents.append(methodToc)
        }

        if tableOfContents.isEmpty {
            return ""
        }

        return """
        **Contents**

        \(tableOfContents.joined(separator: "\n"))
        """
    }

    var markdown: String {
        let toc = options.tableOfContents ? tableOfContents : ""
        let cases = collectionOutput(title: "## Cases", collection: self.cases)
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)

        return """
        **ENUM**

        # `\(name)`

        \(toc)

        \(declaration)

        \(comment.blockquoted)

        \(cases)

        \(properties)

        \(methods)
        """
    }

    func checkDocumentation() -> DocumentationStatus {
        var status = DocumentationStatus(self)

        status += cases.reduce(DocumentationStatus(), { (status: DocumentationStatus, documentable) in
            return status + documentable.checkDocumentation()
        })

        status += properties.reduce(DocumentationStatus(), { (status: DocumentationStatus, documentable) in
            return status + documentable.checkDocumentation()
        })

        status += methods.reduce(DocumentationStatus(), { (status: DocumentationStatus, documentable) in
            return status + documentable.checkDocumentation()
        })

        return status
    }
}

struct MarkdownEnumCaseElement: SwiftDocDictionaryInitializable, MarkdownConvertible, Documentable {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.isKind([.enumelement]) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var markdown: String {
        return """
        ### `\(name)`

        \(declaration)

        \(comment.blockquoted)
        """
    }
}
