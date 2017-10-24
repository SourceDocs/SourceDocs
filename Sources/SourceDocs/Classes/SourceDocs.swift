//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Commandant

struct SourceDocs {
    static let version = "0.4.0"

    func run() {
//        let registry = makeRegistry()
//        registry.main(defaultVerb: defaultVerb()) { error in
//            fputs(error.localizedDescription + "\n", stderr)
//        }

        let config = [
            ArgumentType.flag(name: "version", shortcut: "v", description: "Prints the executable version")
        ]
        let arguments = Arguments(overview: "Generate Markdown reference documentation from inline source code comments", config: config)
        print(arguments.help)
    }

//    private func makeRegistry() -> CommandRegistry<SourceDocsError> {
//        let registry = CommandRegistry<SourceDocsError>()
//        registry.register(GenerateCommand())
//        registry.register(VersionCommand())
//        registry.register(HelpCommand(registry: registry))
//        return registry
//    }
//
//    private func defaultVerb() -> String {
//        let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
//        if arguments.contains("--help") {
//            return "help"
//        } else if arguments.contains("--version") {
//            return "version"
//        }
//        return "generate"
//    }

}
