//
//  Documentable.swift
//  SourceDocs
//
//  Created by xs19on on 18/07/2018.
//

import Foundation

protocol Documentable {
    func checkDocumentation() -> DocumentationStatus
}

extension Documentable where Self: SwiftDocDictionaryInitializable {
    func checkDocumentation() -> DocumentationStatus {
        return DocumentationStatus(self)
    }
}
