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
            var nestedNames: [String] = dictionary.parentNames
            nestedNames.append(name)
            return nestedNames.joined(separator: ".")
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

struct Context {
    var path: [String]
}

private extension String {
    /// The returned string for typeName has a metatype suffix that should be removed
    /// See: https://docs.swift.org/swift-book/ReferenceManual/Types.html#ID455
    func dropMetaTypeSuffix(_ name: String) -> String {
        self.components(separatedBy: ".")
            .reversed()
            .drop { $0 != name }
            .reversed()
            .joined(separator: ".")
    }
}
