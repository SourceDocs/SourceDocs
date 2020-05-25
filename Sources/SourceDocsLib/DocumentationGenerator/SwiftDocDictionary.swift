//
//  SwiftDocDictionary.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

typealias SwiftDocDictionary = [String: Any]

extension Dictionary where Key == String, Value == Any {
    func get<T>(_ key: SwiftDocKey) -> T? {
        return self[key.rawValue] as? T
    }

    var accessLevel: AccessLevel {
        let accessiblityKey = self["key.accessibility"] as? String
        return AccessLevel(accessiblityKey: accessiblityKey)
    }

    func isKind(_ kind: SwiftDeclarationKind) -> Bool {
        return SwiftDeclarationKind(rawValue: get(.kind) ?? "") == kind
    }

    func isKind(_ kinds: [SwiftDeclarationKind]) -> Bool {
        guard let value: String = get(.kind), let kind = SwiftDeclarationKind(rawValue: value) else {
            return false
        }
        return kinds.contains(kind)
    }
}

protocol SwiftDocDictionaryInitializable {
    var dictionary: SwiftDocDictionary { get }

    init?(dictionary: SwiftDocDictionary)
}

extension SwiftDocDictionaryInitializable {
    var name: String {
        let name = dictionary.get(.name) ?? "[NO NAME]"
        if dictionary.isKind([.struct, .class, .enum, .typealias]) {
            return (dictionary.parentNames + [name]).joined(separator: ".")
        } else {
            return name
        }
    }

    var comment: String {
        return dictionary.get(.documentationComment) ?? ""
    }

    var declaration: String {
        guard let declaration: String = dictionary.get(.parsedDeclaration) else {
            return ""
        }
        return MarkdownCodeBlock(code: declaration, style: .backticks(language: "swift")).markdown
    }

    func collectionOutput(title: String, collection: [MarkdownConvertible]) -> String {
        return collection.isEmpty ? "" : """
        \(title)
        \(collection.markdown)
        """
    }
}
