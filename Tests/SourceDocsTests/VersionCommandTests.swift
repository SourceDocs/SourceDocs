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

        let fooBinary = productsDirectory.appendingPathComponent("sourcedocs")

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

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }

}
