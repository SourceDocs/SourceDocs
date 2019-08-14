//
//  Helpers.swift
//  SourceDocsTests
//
//  Created by Eneko Alonso on 8/13/19.
//

import XCTest

let documentationPath = "/tmp/SourceDocs/docs/reference"

extension XCTestCase {

    @discardableResult
    class func generateDocumentation() -> String? {
        #if os(macOS)
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return nil
        }

        let fooBinary = productsDirectory.appendingPathComponent("sourcedocs")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = [
            "generate", "--clean",
            "--spm-module", "SourceDocsDemo",
            "--output-folder", documentationPath,
            "--module-name-path"
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
        #endif
    }

    /// Returns path to the built products directory.
    class var productsDirectory: URL {
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
