//
//  main.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import ArgumentParser

@main
struct SourceDocs: ParsableCommand {
    static let version = "2.0.1"
    static let defaultOutputPath = "Documentation/Reference"
    static let defaultLinkEnding = ".md"
    static let defaultLinkBeginning = ""

    static var configuration = CommandConfiguration(
        subcommands: [
            CleanCommand.self,
            GenerateCommand.self,
            PackageCommand.self,
            VersionCommand.self
        ]
    )
}
