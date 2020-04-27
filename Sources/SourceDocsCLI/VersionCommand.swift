//
//  VersionCommand.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 4/26/20.
//

import Foundation
import ArgumentParser
import Rainbow

struct VersionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "version",
        abstract: "Display the current version of SourceDocs"
    )

    func run() throws {
        fputs("SourceDocs v\(SourceDocs.version)\n".cyan, stdout)
    }
}
