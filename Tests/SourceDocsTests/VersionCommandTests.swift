//
//  VersionCommandTests.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import XCTest
import class Foundation.Bundle

class VersionCommandTests: XCTestCase {

    func testVersion() throws {
        #if os(macOS)
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = XCTestCase.productsDirectory.appendingPathComponent("sourcedocs")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = ["version"]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "SourceDocs v0.5.1\n")
        #endif
    }

}
