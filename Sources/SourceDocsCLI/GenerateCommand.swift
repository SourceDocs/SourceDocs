//
//  GenerateCommand.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation
import ArgumentParser
import SourceDocsLib

extension SourceDocs {
    struct GenerateCommand: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "generate",
            abstract: "Generates the Markdown documentation"
        )

        @Flag(name: .shortAndLong,
              help: "Generate documentation for all modules in a Swift package")
        var allModules = false

        @Option(help: "Generate documentation for Swift Package Manager module")
        var spmModule: String?

        @Option(help: "Generate documentation for a Swift module")
        var moduleName: String?

        @Option(help: "The text to begin links with")
        var linkBeginning = SourceDocs.defaultLinkBeginning

        @Option(help: "The text to end links with")
        var linkEnding = SourceDocs.defaultLinkEnding

        @Option(name: .shortAndLong, help: "Path to the input directory")
        var inputFolder = FileManager.default.currentDirectoryPath

        @Option(name: .shortAndLong, help: "Output directory to clean")
        var outputFolder = SourceDocs.defaultOutputPath

        @Option(help: "Access level to include in documentation [private, fileprivate, internal, public, open]")
        var minACL = AccessLevel.public

        @Flag(name: .shortAndLong, help: "Include the module name as part of the output folder path")
        var moduleNamePath = false

        @Flag(name: .shortAndLong, help: "Delete output folder before generating documentation")
        var clean = false

        @Flag(name: [.long, .customShort("l")],
              help: "Put methods, properties and enum cases inside collapsible blocks")
        var collapsible = false

        @Flag(name: .shortAndLong,
              help: "Generate a table of contents with properties and methods for each type")
        var tableOfContents = false

        @Argument(help: "List of arguments to pass to xcodebuild")
        var xcodeArguments: [String]

        @Flag(
            name: .shortAndLong,
            help: """
        Generate documentation that is reproducible: only depends on the sources.
        For example, this will avoid adding timestamps on the generated files.
        """
        )
        var reproducibleDocs = false

        func run() throws {
            let options = DocumentOptions(allModules: allModules, spmModule: spmModule, moduleName: moduleName,
                                          linkBeginningText: linkBeginning, linkEndingText: linkEnding,
                                          inputFolder: inputFolder, outputFolder: outputFolder,
                                          minimumAccessLevel: minACL, includeModuleNameInPath: moduleNamePath,
                                          clean: clean, collapsibleBlocks: collapsible,
                                          tableOfContents: tableOfContents, xcodeArguments: xcodeArguments,
                                          reproducibleDocs: reproducibleDocs)

            try DocumentationGenerator(options: options).run()
        }
    }
}

extension AccessLevel: ExpressibleByArgument {}
