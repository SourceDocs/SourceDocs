//
//  SourceDocsError.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation

enum SourceDocsError: Error {
    case internalError(message: String)
}

extension SourceDocsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .internalError(message):
            return message
        }
    }
}
