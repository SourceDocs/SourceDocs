//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Commandant
import Rainbow

struct SourceDocs {
    static let version = "0.5.1"
    static let defaultOutputPath = "Documentation/Reference"
    static let defaultLinkEnding = ".md"
    static let defaultLinkBeginning = ""

    func run() {
        let registry = CommandRegistry<SourceDocsError>()
        registry.register(CleanCommand())
        registry.register(GenerateCommand())
        registry.register(VersionCommand())
        registry.register(HelpCommand(registry: registry))

        registry.main(defaultVerb: "help") { error in
            fputs("\(error.localizedDescription)\n)".red, stderr)
        }
    }
}

enum AccessLevel: String {

    init(stringLiteral value: String) {
        switch value {
        case "private":
            self = .private
        case "fileprivate":
            self = .fileprivate
        case "internal":
            self = .internal
        case "public":
            self = .public
        case "open":
            self = .open
        default:
            self = .public
        }
    }

    case `private` = "source.lang.swift.accessibility.private"
    case `fileprivate` = "source.lang.swift.accessibility.fileprivate"
    case `internal` = "source.lang.swift.accessibility.internal"
    case `public` = "source.lang.swift.accessibility.public"
    case `open` = "source.lang.swift.accessibility.open"
    
    var stringValue: String {
        switch self {
        case .private:
            return "private"
        case .fileprivate:
            return "fileprivate"
        case .internal:
            return "internal"
        case .public:
            return "public"
        case .open:
            return "open"
        }
    }
    
    var priority: Int {
        switch self {
        case .private:
            return 0
        case .fileprivate:
            return 1
        case .internal:
            return 2
        case .public:
            return 3
        case .open:
            return 4
        }
    }
}

extension AccessLevel: Comparable, Equatable {
    static func < (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    static func > (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        return lhs.priority > rhs.priority
    }
    
    static func == (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        return lhs.priority == rhs.priority
    }
}
