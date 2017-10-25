//
//  StandardIO.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/24/17.
//

import Foundation

public struct StandardIO {
    public static var standardOutput = StandardOutput()
    public static var standardError = StandardError()
}

public struct StandardOutput: TextOutputStream {
    let stdout = FileHandle.standardOutput

    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            stdout.write(data)
        }
    }
}

public struct StandardError: TextOutputStream {
    let stderr = FileHandle.standardError

    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            stderr.write(data)
        }
    }
}
