//
//  Generate.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation
import Commandant
import Rainbow
import Curry
import SourceKittenFramework
import SourceDocsLib

public struct GenerateCommandOptions: OptionsProtocol {
    let spmModule: String?
    let moduleName: String?
    let linkBeginningText: String
    let linkEndingText: String
    let inputFolder: String
    let outputFolder: String
    let minimumAccessLevel: String
    let includeModuleNameInPath: Bool
    let clean: Bool
    let collapsibleBlocks: Bool
    let tableOfContents: Bool
    let xcodeArguments: [String]

    /// Initializer for options object for the Generate command
    ///
    /// - Parameters:
    ///   - spmModule: Generate documentation for Swift Package Manager module.
    ///   - moduleName: Generate documentation for a Swift module.
    ///   - linkBeginningText: The text to begin links with. Defaults to an empty string.
    ///   - linkEndingText: The text to end links with. Defaults to .md.
    ///   - inputFolder: Path to the input directory (defaults to the current directory).
    ///   - outputFolder: Output directory (defaults to "Documentation/Reference").
    ///   - minimumAccessLevel: The minimum access level to generate documentation. Defaults to public.
    ///   - includeModuleNameInPath: Include the module name as part of the output folder path. Defaults to false.
    ///   - clean: Delete output folder before generating documentation. Defaults to false.
    ///   - collapsibleBlocks: Put methods, properties and enum cases inside collapsible blocks. Defaults to false.
    ///   - tableOfContents: Generate a table of contents with properties and methods for each type. Defaults to false.
    ///   - xcodeArguments: Array of `String` arguments to pass to xcodebuild. Defaults to an empty array.
    public init(spmModule: String? = nil,
                moduleName: String? = nil,
                linkBeginningText: String = SourceDocsLib.defaultLinkBeginning,
                linkEndingText: String = SourceDocsLib.defaultLinkEnding,
                inputFolder: String = FileManager.default.currentDirectoryPath,
                outputFolder: String = SourceDocsLib.defaultOutputPath,
                minimumAccessLevel: String = AccessLevel.public.rawValue,
                includeModuleNameInPath: Bool = false,
                clean: Bool = false,
                collapsibleBlocks: Bool = false,
                tableOfContents: Bool = false,
                xcodeArguments: [String] = []) {
        self.spmModule = spmModule
        self.moduleName = moduleName
        self.linkBeginningText = linkBeginningText
        self.linkEndingText = linkEndingText
        self.inputFolder = inputFolder
        self.outputFolder = outputFolder
        self.minimumAccessLevel = minimumAccessLevel
        self.includeModuleNameInPath = includeModuleNameInPath
        self.clean = clean
        self.collapsibleBlocks = collapsibleBlocks
        self.tableOfContents = tableOfContents
        self.xcodeArguments = xcodeArguments
    }

    public static func evaluate(_ mode: CommandMode) -> Result<GenerateCommandOptions, CommandantError<SourceDocsError>> {
        return curry(self.init)
            <*> mode <| Option(key: "spm-module", defaultValue: nil,
                               usage: "Generate documentation for Swift Package Manager module.")
            <*> mode <| Option(key: "module-name", defaultValue: nil,
                               usage: "Generate documentation for a Swift module.")
            <*> mode <| Option(key: "link-beginning", defaultValue: SourceDocsLib.defaultLinkBeginning,
                               usage: "The text to begin links with. Defaults to an empty string.")
            <*> mode <| Option(key: "link-ending", defaultValue: SourceDocsLib.defaultLinkEnding,
                               usage: "The text to end links with. Defaults to \(SourceDocsLib.defaultLinkEnding).")
            <*> mode <| Option(key: "input-folder", defaultValue: FileManager.default.currentDirectoryPath,
                               usage:
                "Path to the input directory (defaults to \(FileManager.default.currentDirectoryPath))."
            )
            <*> mode <| Option(key: "output-folder", defaultValue: SourceDocsLib.defaultOutputPath,
                               usage: "Output directory (defaults to \(SourceDocsLib.defaultOutputPath)).")
            <*> mode <| Option(key: "min-acl", defaultValue: AccessLevel.public.rawValue,
                               usage:
                "The minimum access level to generate documentation. Defaults to \(AccessLevel.public.rawValue)."
            )
            <*> mode <| Switch(flag: "m", key: "module-name-path",
                               usage: "Include the module name as part of the output folder path.")
            <*> mode <| Switch(flag: "c", key: "clean",
                               usage: "Delete output folder before generating documentation.")
            <*> mode <| Switch(flag: "l", key: "collapsible",
                               usage: "Put methods, properties and enum cases inside collapsible blocks.")
            <*> mode <| Switch(flag: "t", key: "table-of-contents",
                               usage: "Generate a table of contents with properties and methods for each type.")
            <*> mode <| Argument(defaultValue: [], usage: "List of arguments to pass to xcodebuild.")
    }
}

public struct GenerateCommand: CommandProtocol {
    public typealias Options = GenerateCommandOptions

    public let verb = "generate"
    public let function = "Generates the Markdown documentation"

    public init() {}

    public func run(_ options: GenerateCommandOptions) -> Result<(), SourceDocsError> {
        defer {
            // Reset the markdown index in case multiple libs are having things generated
            MarkdownIndex.shared.reset()
        }
        do {
            if let module = options.spmModule {
                let docs = try parseSPMModule(moduleName: module)
                try generateDocumentation(docs: docs, options: options, module: module)
            } else if let module = options.moduleName {
                let docs = try parseSwiftModule(moduleName: module, args: options.xcodeArguments,
                                                path: options.inputFolder)
                try generateDocumentation(docs: docs, options: options, module: module)
            } else {
                let docs = try parseXcodeProject(args: options.xcodeArguments, inputPath: options.inputFolder)
                try generateDocumentation(docs: docs, options: options, module: "")
            }
            return Result.success(())
        } catch let error as SourceDocsError {
            return Result.failure(error)
        } catch let error {
            return Result.failure(SourceDocsError.internalError(message: error.localizedDescription))
        }
    }

    private func parseSPMModule(moduleName: String) throws -> [SwiftDocs] {
        guard let docs = Module(spmName: moduleName)?.docs else {
            let message = "Error: Failed to generate documentation for SPM module '\(moduleName)'."
            throw SourceDocsError.internalError(message: message)
        }
        return docs
    }

    private func parseSwiftModule(moduleName: String, args: [String], path: String) throws -> [SwiftDocs] {
        guard let docs = Module(xcodeBuildArguments: args, name: moduleName, inPath: path)?.docs else {
            let message = "Error: Failed to generate documentation for module '\(moduleName)'."
            throw SourceDocsError.internalError(message: message)
        }
        return docs
    }

    private func parseXcodeProject(args: [String], inputPath: String) throws -> [SwiftDocs] {
        guard let docs = Module(xcodeBuildArguments: args, name: nil, inPath: inputPath)?.docs else {
            throw SourceDocsError.internalError(message: "Error: Failed to generate documentation.")
        }
        return docs
    }

    private func generateDocumentation(docs: [SwiftDocs], options: GenerateCommandOptions, module: String) throws {
        let docsPath = options.includeModuleNameInPath ? "\(options.outputFolder)/\(module)" : options.outputFolder
        if options.clean {
            try CleanCommand.removeReferenceDocs(docsPath: docsPath)
        }
        process(docs: docs, options: options)
        try MarkdownIndex.shared.write(to: docsPath,
                                       linkBeginningText: options.linkBeginningText,
                                       linkEndingText: options.linkEndingText)
    }

    private func process(docs: [SwiftDocs], options: GenerateCommandOptions) {
        let dictionaries = docs.compactMap { $0.docsDictionary.bridge() as? SwiftDocDictionary }
        process(dictionaries: dictionaries, options: options)
    }

    private func process(dictionaries: [SwiftDocDictionary], options: GenerateCommandOptions) {
        dictionaries.forEach { process(dictionary: $0, options: options) }
    }

    private func process(dictionary: SwiftDocDictionary, options: GenerateCommandOptions) {
        let minimumAccessLevel = AccessLevel(rawValue: options.minimumAccessLevel) ?? .public
        let markdownOptions = MarkdownOptions(collapsibleBlocks: options.collapsibleBlocks,
                                              tableOfContents: options.tableOfContents,
                                              minimumAccessLevel: minimumAccessLevel)

        if let value: String = dictionary.get(.kind), let kind = SwiftDeclarationKind(rawValue: value) {
            if kind == .struct, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.structs.append(item)
            } else if kind == .class, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.classes.append(item)
            } else if let item = MarkdownExtension(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.extensions.append(item)
            } else if let item = MarkdownEnum(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.enums.append(item)
            } else if let item = MarkdownProtocol(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.protocols.append(item)
            } else if let item = MarkdownTypealias(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.typealiases.append(item)
            } else if kind == .functionFree,
                let item = MarkdownMethod(dictionary: dictionary, options: markdownOptions) {
                MarkdownIndex.shared.methods.append(item)
            }
        }

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDocDictionary] {
            process(dictionaries: substructure, options: options)
        }
    }
}
