//
//  Generate.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/19/17.
//

import Foundation
import Commandant
import Rainbow
import Result
import Curry
import SourceKittenFramework

fileprivate let defaultOutputPath = FileManager.default.currentDirectoryPath + "/Docs/Reference"

struct GenerateCommandOptions: OptionsProtocol {
    let spmModule: String?
    let moduleName: String?
    let outputFolder: String
    let clean: Bool
    let xcodeArguments: [String]

    static func evaluate(_ mode: CommandMode) -> Result<GenerateCommandOptions, CommandantError<SourceDocsError>> {
        return curry(self.init)
            <*> mode <| Option(key: "spm-module", defaultValue: nil, usage: "Generate documentation for Swift Package Manager module")
            <*> mode <| Option(key: "module-name", defaultValue: nil, usage: "Generate documentation for a Swift module")
            <*> mode <| Option(key: "output-folder", defaultValue: defaultOutputPath, usage: "Output directory (defaults to Docs/Reference)")
            <*> mode <| Switch(flag: "c", key: "clean", usage: "Delete output folder before generating documentation")
            <*> mode <| Argument(defaultValue: [], usage: "List of arguments to pass to xcodebuild")
    }

//    typealias ClientError = SourceDocsError
}

struct GenerateCommand: CommandProtocol {
    typealias Options = GenerateCommandOptions

    static let verb = "generate"
    var verb: String {
        return GenerateCommand.verb
    }
    let function = "Generates the Markdown documentation"

    var docsPath = defaultOutputPath

    func run(_ options: GenerateCommandOptions) -> Result<(), SourceDocsError> {
        do {
            if options.clean {
                try removeReferenceDocs(docsPath: options.outputFolder)
            }
            if let module = options.spmModule {
                try runSPMModule(moduleName: module)
            } else if let module = options.moduleName {
                try runSwiftModule(moduleName: module, args: options.xcodeArguments)
            } else {
                try runXcode(args: options.xcodeArguments)
            }
            return Result.success(())
        }
        catch let error {
            print(error.localizedDescription.red)
            return Result.failure(SourceDocsError.internalError)
        }
    }

    private func runSPMModule(moduleName: String) throws {
        guard let docs = Module(spmName: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red)
            print("Please, try running 'sourcekitten doc --spm-module \(moduleName)' for more information.")
            return
        }
        process(docs: docs)
        try MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

    private func runSwiftModule(moduleName: String, args: [String]) throws {
        guard let docs = Module(xcodeBuildArguments: args, name: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red)
            print("Please, try running 'sourcekitten doc --module-name \(moduleName)' for more information.")
            return
        }
        process(docs: docs)
        try MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

    private func runXcode(args: [String]) throws {
        guard let docs = Module(xcodeBuildArguments: args, name: nil)?.docs else {
            print("Error: Failed to generate documentation".red)
            print("Please, try running 'sourcekitten doc' for more information.")
            return
        }
        process(docs: docs)
        try MarkdownIndex.shared.write(to: "\(docsPath)")
    }

    private func process(docs: [SwiftDocs]) {
        let dictionaries = docs.flatMap { $0.docsDictionary.bridge() as? SwiftDocDictionary }
        process(dictionaries: dictionaries)
    }

    private func process(dictionaries: [SwiftDocDictionary]) {
        dictionaries.forEach { process(dictionary: $0) }
    }

    private func process(dictionary: SwiftDocDictionary) {
        if let value: String = dictionary.get(.kind), let kind = SwiftDeclarationKind(rawValue: value) {
            if kind == .struct, let item = MarkdownObject(dictionary: dictionary) {
                MarkdownIndex.shared.structs.append(item)
            } else if kind == .class, let item = MarkdownObject(dictionary: dictionary) {
                MarkdownIndex.shared.classes.append(item)
            } else if [.extension, .extensionProtocol, .extensionStruct, .extensionClass, .extensionEnum].contains(kind),
                let item = MarkdownExtension(dictionary: dictionary) {
                MarkdownIndex.shared.extensions.append(item)
            } else if kind == .enum, let item = MarkdownEnum(dictionary: dictionary) {
                MarkdownIndex.shared.enums.append(item)
            } else if kind == .protocol, let item = MarkdownProtocol(dictionary: dictionary) {
                MarkdownIndex.shared.protocols.append(item)
            } else if kind == .typealias, let item = MarkdownTypealias(dictionary: dictionary) {
                MarkdownIndex.shared.typealiases.append(item)
            }
        }

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDocDictionary] {
            process(dictionaries: substructure)
        }
    }

    private func removeReferenceDocs(docsPath: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: docsPath, isDirectory: &isDir) {
            print("Removing Reference Docs at '\(docsPath)'")
            try FileManager.default.removeItem(atPath: docsPath)
            print("Done.".green)
        } else {
            print("Could not find any Reference Docs at '\(docsPath)'")
        }
    }

}

