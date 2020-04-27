//
//  CleanCommand.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/24/17.
//

import Foundation
import ArgumentParser
import SourceDocsLib

struct CleanCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "clean",
        abstract: "Delete the output folder and quit."
    )

    @Option(name: .shortAndLong, default: SourceDocs.defaultOutputPath, help: "Output directory to clean")
    var outputFolder: String

    func run() throws {
        try DocumentationEraser(docsPath: outputFolder).run()
    }
}
