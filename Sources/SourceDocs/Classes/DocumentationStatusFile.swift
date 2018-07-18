//
//  DocumentationStatusFile.swift
//  SourceDocs
//
//  Created by xs19on on 18/07/2018.
//

import Foundation

struct DocumentationStatusFile: Writeable {
    let basePath: String
    let status: DocumentationStatus

    var filePath: String {
        return basePath + "/documentation_status.json"
    }

    func write() throws {
        try status.json().write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
