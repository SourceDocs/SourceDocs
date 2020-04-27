//
//  main.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import ArgumentParser

struct SourceDocs: ParsableCommand {
    static let version = "1.0.0"
    static let defaultOutputPath = "Documentation/Reference"
    static let defaultLinkEnding = ".md"
    static let defaultLinkBeginning = ""

    static var configuration = CommandConfiguration(
        subcommands: [
            CleanCommand.self,
            GenerateCommand.self,
            VersionCommand.self
        ]
    )
}

SourceDocs.main()
