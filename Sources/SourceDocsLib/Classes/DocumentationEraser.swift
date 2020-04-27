//
//  DocumentationEraser.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 4/26/20.
//

import Foundation
import Rainbow

public final class DocumentationEraser {

    let docsPath: String

    public init(docsPath: String) {
        self.docsPath = docsPath
    }

    public func run() throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: docsPath, isDirectory: &isDir) {
            fputs("Removing reference documentation at '\(docsPath)'...".green, stdout)
            do {
                try FileManager.default.removeItem(atPath: docsPath)
                fputs(" ✔".green + "\n", stdout)
            } catch let error {
                fputs(" ❌\n", stdout)
                throw error
            }
        } else {
            fputs("Did not find any reference docs at '\(docsPath)'.\n", stdout)
        }
    }
}
