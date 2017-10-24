//
//  Arguments.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/20/17.
//

import Foundation

public enum ArgumentType {
    case flag(name: String, shortcut: String, description: String)
    case parameter(name: String, shortcut: String, defaultValue: String?, description: String)

    var description: String {
        switch self {
        case let .flag(_, _, description):
            return """
                \(argumentName)
                    \(description)
            """
        case let .parameter(_, _, defaultValue, description):
            if let defaultValue = defaultValue {
                return """
                    \(argumentName)
                        \(description)
                        Default value: \(defaultValue)
                """
            } else {
                return """
                    \(argumentName)
                        \(description)
                """
            }
        }
    }

    var argumentName: String {
        switch self {
        case let .flag(name, shortcut, _):
            return shortcut.isEmpty ? "--\(name)" : "--\(name), -\(shortcut)"
        case let .parameter(name, shortcut, _, _):
            return shortcut.isEmpty ? "--\(name)" : "--\(name), -\(shortcut)"
        }
    }

    public static var help: ArgumentType {
        return ArgumentType.flag(name: "help", shortcut: "h", description: "Prints this help")
    }
}

public struct Arguments {
    public let overview: String
    public let config: [ArgumentType]

    private let executable: String

    public init(overview: String, config: [ArgumentType]) {
        self.overview = overview
        self.config = config + [ArgumentType.help]

        var processArguments = ProcessInfo.processInfo.arguments
        executable = processArguments.removeFirst()
    }

    public func flag(name: String) -> Bool {
        return false
    }

    public func parameter(name: String) -> String? {
        return nil
    }

    public var help: String {
        let options = config.map { $0.description }.joined(separator: "\n\n")
        return """
        OVERVIEW: \(overview)

        USAGE:
        \(executable) <options>

        OPTIONS:
        \(options)
        """
    }
}
