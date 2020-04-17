//
//  MarkdownTypealias.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

public struct MarkdownTypealias: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    public init?(dictionary: SwiftDocDictionary, options: MarkdownOptions) {
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
    }

    public var markdown: String {
        return """
        **TYPEALIAS**

        # `\(name)`

        \(declaration)

        \(comment.blockquoted)
        """
    }
}
