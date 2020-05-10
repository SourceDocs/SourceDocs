//
//  DocumentationGenerator.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 4/26/20.
//

import Foundation
import SourceKittenFramework

/// Configuration for DocumentationGenerator
///
/// - Parameters:
///   - spmModule: Generate documentation for Swift Package Manager module.
///   - moduleName: Generate documentation for a Swift module.
///   - linkBeginningText: The text to begin links with. Defaults to an empty string.
///   - linkEndingText: The text to end links with. Defaults to '.md'.
///   - inputFolder: Path to the input directory.
///   - outputFolder: Output directory.
///   - minimumAccessLevel: The minimum access level to generate documentation. Defaults to public.
///   - includeModuleNameInPath: Include the module name as part of the output folder path. Defaults to false.
///   - clean: Delete output folder before generating documentation. Defaults to false.
///   - collapsibleBlocks: Put methods, properties and enum cases inside collapsible blocks. Defaults to false.
///   - tableOfContents: Generate a table of contents with properties and methods for each type. Defaults to false.
///   - xcodeArguments: Array of `String` arguments to pass to xcodebuild. Defaults to an empty array.
public struct DocumentOptions {
    public let spmModule: String?
    public let moduleName: String?
    public let linkBeginningText: String
    public let linkEndingText: String
    public let inputFolder: String
    public let outputFolder: String
    public let minimumAccessLevel: AccessLevel
    public let includeModuleNameInPath: Bool
    public let clean: Bool
    public let collapsibleBlocks: Bool
    public let tableOfContents: Bool
    public let xcodeArguments: [String]

    public init(spmModule: String?, moduleName: String?,
                linkBeginningText: String = "", linkEndingText: String = ".md",
                inputFolder: String, outputFolder: String,
                minimumAccessLevel: AccessLevel = .public, includeModuleNameInPath: Bool = false,
                clean: Bool = false, collapsibleBlocks: Bool = false, tableOfContents: Bool = false,
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
}

public final class DocumentationGenerator {

    let options: DocumentOptions
    let markdownIndex: MarkdownIndex

    public init(options: DocumentOptions) {
        self.options = options
        self.markdownIndex = MarkdownIndex()
    }

    public func run() throws {
        markdownIndex.reset()

        do {
            if let module = options.spmModule {
                let docs = try parseSPMModule(moduleName: module, path: options.inputFolder)
                try generateDocumentation(docs: docs, module: module)
            } else if let module = options.moduleName {
                let docs = try parseSwiftModule(moduleName: module, args: options.xcodeArguments,
                                                path: options.inputFolder)
                try generateDocumentation(docs: docs, module: module)
            } else {
                let docs = try parseXcodeProject(args: options.xcodeArguments, inputPath: options.inputFolder)
                try generateDocumentation(docs: docs, module: "")
            }
        } catch let error as SourceDocsError {
            throw error
        } catch let error {
            throw SourceDocsError.internalError(message: error.localizedDescription)
        }
    }

    private func parseSPMModule(moduleName: String, path: String) throws -> [SwiftDocs] {
        guard let docs = Module(spmName: moduleName, inPath: path)?.docs else {
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

    private func generateDocumentation(docs: [SwiftDocs], module: String) throws {
        let docsPath = options.includeModuleNameInPath ? "\(options.outputFolder)/\(module)" : options.outputFolder
        if options.clean {
            try DocumentationEraser(docsPath: docsPath).run()
        }
        process(docs: docs)
        try markdownIndex.write(to: docsPath,
                                linkBeginningText: options.linkBeginningText,
                                linkEndingText: options.linkEndingText)
    }

    private func process(docs: [SwiftDocs]) {
        let dictionaries = docs.compactMap { $0.docsDictionary.bridge() as? SwiftDocDictionary }
        process(dictionaries: dictionaries)
    }

    private func process(dictionaries: [SwiftDocDictionary]) {
        dictionaries.forEach { process(dictionary: $0) }
    }

    private func process(dictionary: SwiftDocDictionary) {
        let markdownOptions = MarkdownOptions(collapsibleBlocks: options.collapsibleBlocks,
                                              tableOfContents: options.tableOfContents,
                                              minimumAccessLevel: options.minimumAccessLevel)

        if let value: String = dictionary.get(.kind), let kind = SwiftDeclarationKind(rawValue: value) {
            if kind == .struct, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.structs.append(item)
            } else if kind == .class, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.classes.append(item)
            } else if let item = MarkdownExtension(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.extensions.append(item)
            } else if let item = MarkdownEnum(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.enums.append(item)
            } else if let item = MarkdownProtocol(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.protocols.append(item)
            } else if let item = MarkdownTypealias(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.typealiases.append(item)
            } else if kind == .functionFree,
                let item = MarkdownMethod(dictionary: dictionary, options: markdownOptions) {
                markdownIndex.methods.append(item)
            }
        }

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDocDictionary] {
            process(dictionaries: substructure)
        }
    }
}
