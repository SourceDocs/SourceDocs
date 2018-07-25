//
//  DocumentationStatusFile.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 18/07/2018.
//

import Foundation

struct DocumentationStatusFile: Writeable {
    let basePath: String
    let status: DocumentationStatus

    var filePath: String {
        return basePath + "/" + SourceDocs.defaultStatusFilename
    }

    func write() throws {
        try status.json().write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
