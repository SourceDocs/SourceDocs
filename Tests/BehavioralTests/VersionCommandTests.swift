//
//  VersionCommandTests.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import XCTest
import System

class VersionCommandTests: XCTestCase {

    func testVersion() throws {
        let result = try system(command: binaryURL.path, parameters: ["version"], captureOutput: true)
        XCTAssertEqual(result.standardOutput, "SourceDocs v0.6.0")
    }

}
