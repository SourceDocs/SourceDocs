//
//  File.swift
//  
//
//  Created by Eneko Alonso on 11/1/19.
//

import Foundation

enum AccessLevel: String, CaseIterable {

    init(stringLiteral value: String) {
        switch value {
        case "source.lang.swift.accessibility.private":
            self = .private
        case "source.lang.swift.accessibility.fileprivate":
            self = .fileprivate
        case "source.lang.swift.accessibility.internal":
            self = .internal
        case "source.lang.swift.accessibility.public":
            self = .public
        case "source.lang.swift.accessibility.open":
            self = .open
        default:
            self = .private
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

//    static func > (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
//        return lhs.priority > rhs.priority
//    }

    static func == (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        return lhs.priority == rhs.priority
    }
}
