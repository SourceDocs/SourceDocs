//
//  MarkdownElements.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownObject: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.struct, .class]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }
    }

    var elementType: String {
        if dictionary.isKind(.struct) {
            return "struct"
        }
        if dictionary.isKind(.class) {
            return "class"
        }
        return ""
    }

    var tableOfContents: String {
        var tableOfContents: [String] = []

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
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)

        return """
        **\(elementType.uppercased())**
        # `\(name)`

        \(tableOfContents)

        \(declaration)

        \(typename)

        \(comment.blockquoted)

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownEnum: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let cases: [MarkdownEnumCaseElement]
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.enum]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            cases = structure.flatMap {
                guard let substructure: [SwiftDocDictionary] = $0.get(.substructure), let first = substructure.first else {
                    return nil
                }
                return MarkdownEnumCaseElement(dictionary: first)
            }
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
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
        let cases = collectionOutput(title: "## Cases", collection: self.cases)
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        **ENUM**
        # `\(name)`

        \(tableOfContents)

        \(declaration)

        \(typename)

        \(comment.blockquoted)

        \(cases)

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownEnumCaseElement: SwiftDocDictionaryInitializable, MarkdownConvertible {
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

        \(typename)

        \(comment.blockquoted)
        """
    }
}

struct MarkdownProtocol: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }
    }

    var markdown: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        **PROTOCOL**
        # `\(name)`

        \(declaration)

        \(typename)

        \(comment.blockquoted)

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownTypealias: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var markdown: String {
        return """
        **TYPEALIAS**
        # `\(name)`

        \(declaration)

        \(typename)

        \(comment.blockquoted)
        """
    }
}

struct MarkdownExtension: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    var properties: [MarkdownVariable]
    var methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.isKind([.extension, .extensionEnum, .extensionClass, .extensionStruct, .extensionProtocol]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }

        // Extensions ACL is defined by their properties and methods
        if properties.isEmpty && methods.isEmpty {
            return nil
        }
    }

    var markdown: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        **EXTENSION**
        # `\(name)`

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownVariable: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind(.varInstance) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var markdown: String {
        return """
        ### `\(name)`

        \(declaration)

        \(typename)

        \(comment.blockquoted)
        """
    }
}

struct MarkdownMethod: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let parameters: [MarkdownMethodParameter]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.functionMethodInstance, .functionMethodStatic, .functionMethodClass]) else {
            return nil
        }
        self.dictionary = dictionary
        if let params: [SwiftDocDictionary] = dictionary.get(.docParameters) {
            parameters = params.flatMap { MarkdownMethodParameter(dictionary: $0) }
        } else {
            parameters = []
        }
    }

    var parametersTable: String {
        if parameters.isEmpty {
            return ""
        }
        let data: [[String]] = parameters.map { [$0.name, $0.description] }
        let table = MarkdownTable(headers: ["Name", "Description"], data: data)
        return """
        #### Parameters
        \(table.markdown)
        """
    }

    var markdown: String {
        return """
        ### `\(name)`

        \(declaration)

        \(typename)

        \(comment.blockquoted)

        \(parametersTable)
        """
    }
}

struct MarkdownMethodParameter: SwiftDocDictionaryInitializable {
    let dictionary: SwiftDocDictionary
    let name: String
    let description: String

    init?(dictionary: SwiftDocDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String ?? "[NO NAME]"
        if let discussion = dictionary["discussion"] as? [SwiftDocDictionary] {
            description = discussion.flatMap { $0["Para"] as? String }.joined(separator: " ")
        } else {
            description = ""
        }
    }
}

