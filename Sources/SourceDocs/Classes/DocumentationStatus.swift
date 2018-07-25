//
//  DocumentationStatus.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 16/07/2018.
//

import Foundation

typealias JSON = [String: Any]

struct DocumentationStatus {
    private var interfaces: [JSON]?

    var undocumentedInterfaces: [JSON]? {
        return interfaces?.filter { !($0["isDocumented"] as? Bool ?? true) }
    }

    var documentedInterfaces: [JSON]? {
        return interfaces?.filter { $0["isDocumented"] as? Bool ?? false }
    }

    var interfaceCount: Int {
        return interfaces?.count ?? 0
    }

    var documentedCount: Int {
        return documentedInterfaces?.count ?? 0
    }

    var undocumentedCount: Int {
        return undocumentedInterfaces?.count ?? 0
    }

    var precentage: Double {
        return Double(interfaceCount - undocumentedCount) / Double(interfaceCount)
    }

    init(_ documentable: SwiftDocDictionaryInitializable? = nil) {
        if let debugInfo = documentable?.debugInfo {
            self.init(interfaces: [debugInfo])
        } else {
            self.init(interfaces: nil)
        }
    }

    private init(interfaces: [JSON]? = nil) {
        self.interfaces = interfaces
    }

    static func + (left: DocumentationStatus, right: DocumentationStatus) -> DocumentationStatus {
        guard let leftInterfaces = left.interfaces else {
            return DocumentationStatus(interfaces: right.interfaces)
        }
        guard let rightInterfaces = right.interfaces else {
            return DocumentationStatus(interfaces: leftInterfaces)
        }
        return DocumentationStatus(interfaces: leftInterfaces + rightInterfaces)
    }

    static func += (left: inout DocumentationStatus, right: DocumentationStatus) {
        left = left + right
    }

    func json() -> String {
        var dictionary: [String : Any] = [
            "interfaceCount": interfaceCount,
            "documentedCount": documentedCount,
            "undocumentedCount": undocumentedCount
        ]

        if let documentedInterfaces = documentedInterfaces, !documentedInterfaces.isEmpty {
            dictionary["documentedInterfaces"] = documentedInterfaces
        }

        if let undocumentedInterfaces = undocumentedInterfaces, !undocumentedInterfaces.isEmpty {
            dictionary["undocumentedInterfaces"] = undocumentedInterfaces
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted), let jsonString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
}
