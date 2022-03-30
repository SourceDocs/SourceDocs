//
//  VersionCommandTests.swift
//  SourceDocsCLITests
//
//  Created by Eneko Alonso on 10/5/17.
//

import XCTest
import ProcessRunner

class VersionCommandTests: XCTestCase {

    let expectedVersion = "2.0.1"

    func testVersion() throws {
        let result = try system(command: binaryURL.path, parameters: ["version"], captureOutput: true)
        XCTAssertEqual(result.standardOutput, "SourceDocs v\(expectedVersion)")
    }

}
