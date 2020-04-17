//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Commandant
import Rainbow

public struct SourceDocs {
    public init() {}

    public func run(arguments: [String] = CommandLine.arguments) {
        let registry = CommandRegistry<SourceDocsError>()
        registry.register(CleanCommand())
        registry.register(GenerateCommand())
        registry.register(VersionCommand())
        registry.register(HelpCommand(registry: registry))

        registry.main(arguments: arguments, defaultVerb: "help") { error in
            fputs("\(error.localizedDescription)\n)".red, stderr)
        }
    }
}
