//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Rainbow
import SourceKittenFramework

extension Array {
    func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        return self[index]
    }
}

struct SourceDocs {

    let version = "0.3.0"

    /// Base path for generated Markdown reference documentation
    /// Note: Constant for now, could be parametrized later on
    let docsPath = "Docs/Reference"

    func run(arguments: [String]) {
        do {
            if arguments.get(at: 0) == "--help" {
                printHelp()
            } else if arguments.get(at: 0) == "--clean" {
                try removeReferenceDocs()
            } else if arguments.get(at: 0) == "--version" {
                print(version)
            } else if arguments.get(at: 0) == "--spm-module", let module = arguments.get(at: 1) {
                try runSPMModule(moduleName: module)
            } else if arguments.get(at: 0) == "--module", let module = arguments.get(at: 1) {
                let xcodeArguments = Array(arguments.dropFirst(2))
                try runSwiftModule(moduleName: module, args: xcodeArguments)
            } else {
                try runXcode(args: arguments)
            }
        }
        catch let error {
            print(error.localizedDescription.red, to: &StandardIO.standardError)
        }
    }

    private func printHelp() {
        let help = """
        SourceDocs v\(version)

        OVERVIEW: Generate Markdown reference documentation from inline source code comments

        USAGE:
            sourcedocs [xcodebuild arguments]
            sourcedocs --spm-module <module name>
            sourcedocs --module <module name> [xcodebuild arguments]

        OPTIONS:
          [xcodebuild arguments]
            Optional parameters to pass to xcodebuild needed to build (scheme, workspace, etc)

          --spm-module <module name>
            Name of the Swift Package Manager module to build

          --module <module name> (optional)
            Name of the Swift module to build with xcodebuild

          --clean
            Delete reference documentation directory (\(docsPath))

          --version
            Prints the executable version

          --help
            Prints this help
        """
        print(help, to: &StandardIO.standardOutput)
    }

    private func removeReferenceDocs() throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: docsPath, isDirectory: &isDir) {
            print("Removing Reference Docs at '\(docsPath)'", to: &StandardIO.standardOutput)
            try FileManager.default.removeItem(atPath: docsPath)
            print("Done.".green, to: &StandardIO.standardOutput)
        } else {
            print("Did not find any Reference Docs at '\(docsPath)'", to: &StandardIO.standardOutput)
        }
    }

    private func runSPMModule(moduleName: String) throws {
        guard let docs = Module(spmName: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red, to: &StandardIO.standardError)
            print("Please, try running 'sourcekitten doc --spm-module \(moduleName)' for more information.", to: &StandardIO.standardError)
            return
        }
        process(docs: docs)
        try MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

    private func runSwiftModule(moduleName: String, args: [String]) throws {
        guard let docs = Module(xcodeBuildArguments: args, name: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red, to: &StandardIO.standardError)
            print("Please, try running 'sourcekitten doc --module-name \(moduleName)' for more information.", to: &StandardIO.standardError)
            return
        }
        process(docs: docs)
        try MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

    private func runXcode(args: [String]) throws {
        guard let docs = Module(xcodeBuildArguments: args, name: nil)?.docs else {
            print("Error: Failed to generate documentation".red, to: &StandardIO.standardError)
            print("Please, try running 'sourcekitten doc' for more information.", to: &StandardIO.standardError)
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
}
