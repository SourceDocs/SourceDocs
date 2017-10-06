//
//  MarkdownFile.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//

import Foundation
import Rainbow

struct MarkdownFile {
    let filename: String
    let basePath: String
    let content: [MarkdownConvertible]

    var filePath: String {
        return "\(basePath)/\(filename).md"
    }

    func write() throws {
        try createDirectory(path: "\(FileManager.default.currentDirectoryPath)/\(basePath)")
        let absolutePath = "\(FileManager.default.currentDirectoryPath)/\(filePath)"
        print("  Writting documentation file: \(filePath)", terminator: "")
        do {
            try content.output.write(toFile: absolutePath, atomically: true, encoding: .utf8)
            print(" ✔".green)
        } catch let error {
            print(" ❌")
            throw error
        }
    }

    private func createDirectory(path: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) == false {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
