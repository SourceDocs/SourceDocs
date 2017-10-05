import Foundation
import Rainbow
import SourceKittenFramework

struct SourceDocs {

    /// Base path for generated Markdown reference documentation (not including trailing slash)
    /// Note: Constant for now, could be parametrized later on
    let docsPath = "docs/reference"

    func runSPMModule(moduleName: String) {
        guard let docs = Module(spmName: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red)
            print("Please try running 'sourcekitten doc --spm-module \(moduleName)' for more information.")
            return
        }
        process(docs: docs)
        try? MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

    func runSwiftModule(moduleName: String, args: [String]) {
        guard let docs = Module(xcodeBuildArguments: args, name: moduleName)?.docs else {
            print("Error: Failed to generate documentation for module '\(moduleName)'".red)
            print("Please try running 'sourcekitten doc --module-name \(moduleName)' for more information.")
            return
        }
        process(docs: docs)
        try? MarkdownIndex.shared.write(to: "\(docsPath)/\(moduleName)")
    }

//    func runSwiftSingleFile(args: [String]) {
//        if args.isEmpty {
//            print("Error: Failed to generate documentation".red)
//            print("Please try running 'sourcekitten doc --module-name \(moduleName)' for more information.")
//            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--single-file`"))
//        }
//        let sourcekitdArguments = Array(args.dropFirst(1))
//        let filename = args[0]
//        guard let file = File(path: filename), let docs = SwiftDocs(file: file, arguments: sourcekitdArguments) else {
//            return .failure(.readFailed(path: args[0]))
//        }
//        process(docs: [docs])
//        try? MarkdownIndex.shared.write(to: docsPath)
//        return .success(())
//    }

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

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [[String: Any]] {
            process(dictionaries: substructure)
        }
    }
}

SourceDocs().runSPMModule(moduleName: "SourceDocs")
