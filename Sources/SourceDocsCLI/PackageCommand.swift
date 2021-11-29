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
            abstract: "Generate Package.md from Swift package description."
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

        @Flag(name: .shortAndLong, help: "Disable clusters in module dependency diagram")
        var noClusters = false

        func run() throws {
            do {
                let processor = try PackageProcessor(inputPath: inputFolder, outputPath: outputFolder,
                                                    reproducibleDocs: reproducibleDocs)
                processor.clustersEnabled = noClusters == false
                try processor.run()
            } catch PackageProcessor.Error.invalidInput {
                fputs("Error:".red + " Package.swift not found at \(inputFolder)\n".white, stdout)
            } catch {
                throw error
            }
        }
    }
}
