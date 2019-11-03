//
//  File.swift
//  
//
//  Created by Eneko Alonso on 11/1/19.
//

import Foundation

enum AccessLevel: String, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case `open`

    init(accessiblityKey: String?) {
        switch accessiblityKey {
        case .some("source.lang.swift.accessibility.private"):
            self = .private
        case .some("source.lang.swift.accessibility.fileprivate"):
            self = .fileprivate
        case .some("source.lang.swift.accessibility.internal"):
            self = .internal
        case .some("source.lang.swift.accessibility.public"):
            self = .public
        case .some("source.lang.swift.accessibility.open"):
            self = .open
        default:
            self = .private
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

    static func == (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        return lhs.priority == rhs.priority
    }
}
