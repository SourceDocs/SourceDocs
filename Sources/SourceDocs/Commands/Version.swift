//
//  Version.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation
import Commandant
import Result

/// Type that encapsulates the configuration and evaluation of the `version` subcommand.
struct VersionCommand: CommandProtocol {
    let verb = "version"
    let function = "Display the current version of SourceDocs"

    func run(_ options: NoOptions<SourceDocsError>) -> Result<(), SourceDocsError> {
        print(SourceDocs.version)
        return .success(())
    }
}
