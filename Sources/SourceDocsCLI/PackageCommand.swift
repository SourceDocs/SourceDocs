//
//  PackageCommand.swift
//
//
//  Created by Eneko Alonso on 5/1/20.
//

import Foundation
import ArgumentParser
import SourceDocsLib

extension SourceDocs {
    struct PackageCommand: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "package",
            abstract: "Generate PACKAGE.md from Swift package description."
        )

        @Option(name: .shortAndLong,
                help: "Directory where Package.swift is located")
        var inputFolder = FileManager.default.currentDirectoryPath

        @Option(name: .shortAndLong,
                help: "Directory where Package.md will be placed")
        var outputFolder = FileManager.default.currentDirectoryPath

        @Flag(
            name: .shortAndLong,
            help:
        """
        Generate documentation that is reproducible: only depends on the sources.
        For example, this will avoid adding timestamps on the generated files
        """
        )
        var reproducibleDocs = false

        func run() throws {
            do {
                try PackageProcessor(
                    inputPath: inputFolder,
                    outputPath: outputFolder,
                    reproducibleDocs: reproducibleDocs
                ).run()
            } catch PackageProcessor.Error.invalidInput {
                fputs("Error:".red + " Package.swift not found at \(inputFolder)\n".white, stdout)
            } catch {
                throw error
            }
        }
    }
}
