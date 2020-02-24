//
//  Version.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation
import Commandant
import Rainbow

/// Type that encapsulates the configuration and evaluation of the `version` subcommand.
public struct VersionCommand: CommandProtocol {
    public let verb = "version"
    public let function = "Display the current version of SourceDocs"
    
    public init() {}

    public func run(_ options: NoOptions<SourceDocsError>) -> Result<(), SourceDocsError> {
        fputs("SourceDocs v\(SourceDocs.version)\n".cyan, stdout)
        return .success(())
    }
}
