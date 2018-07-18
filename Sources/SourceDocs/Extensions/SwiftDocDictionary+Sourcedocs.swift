//
//  SwiftDocDictionary.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

typealias SwiftDocDictionary = [String: Any]

public extension Dictionary where Key == String, Value == Any {
    /// public info
    var hasPublicACL: Bool {
        let accessLevel: String? = get(.accessibility)
        return accessLevel == "source.lang.swift.accessibility.public" || accessLevel == "source.lang.swift.accessibility.open"
    }

    /// Get the value for the key
    ///
    /// - Parameter key: a `SwiftDocKey` key
    /// - Returns: The object for the key
    func get<T>(_ key: SwiftDocKey) -> T? {
        return self[key.rawValue] as? T
    }

    /// The kind
    ///
    /// - Parameter kind: a `SwiftDeclarationKind`
    /// - Returns: yes or no
    func isKind(_ kind: SwiftDeclarationKind) -> Bool {
        return SwiftDeclarationKind(rawValue: get(.kind) ?? "") == kind
    }

    /// The kinds
    ///
    /// - Parameter kinds: an array of `SwiftDeclarationKind`
    /// - Returns: yes or no
    func isKind(_ kinds: [SwiftDeclarationKind]) -> Bool {
        guard let value: String = get(.kind), let kind = SwiftDeclarationKind(rawValue: value) else {
            return false
        }
        return kinds.contains(kind)
    }
}

