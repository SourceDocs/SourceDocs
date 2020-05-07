//
//  PackageCommand.swift
//  
//
//  Created by Eneko Alonso on 5/1/20.
//

import Foundation
import ArgumentParser
import SourceDocsLib

struct PackageCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "package",
        abstract: "Generate PACKAGE.md from Swift package description."
    )

    @Option(name: .shortAndLong, default: FileManager.default.currentDirectoryPath, help: "Directory where Package.swift is located")
    var inputFolder: String

    @Option(name: .shortAndLong, default: FileManager.default.currentDirectoryPath, help: "Directory where Package.md will be placed")
    var outputFolder: String

    func run() throws {
        try PackageProcessor(inputPath: inputFolder, outputPath: outputFolder).run()
    }
}
