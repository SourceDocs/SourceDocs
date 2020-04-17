//
//  MarkdownProtocol.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

public struct MarkdownProtocol: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    public init?(dictionary: SwiftDocDictionary, options: MarkdownOptions) {
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.compactMap { MarkdownVariable(dictionary: $0, options: options) }
            methods = structure.compactMap { MarkdownMethod(dictionary: $0, options: options) }
        } else {
            properties = []
            methods = []
        }
    }

    public var markdown: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        **PROTOCOL**

        # `\(name)`

        \(declaration)

        \(comment.blockquoted)

        \(properties)

        \(methods)
        """
    }
}
