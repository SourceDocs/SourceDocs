//
//  SourceDocsError.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation

public enum SourceDocsError: Error {
    case internalError(message: String)
}

extension SourceDocsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .internalError(message):
            return message
        }
    }
}
