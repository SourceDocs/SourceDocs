//
//  VersionCommandTests.swift
//  SourceDocsCLITests
//
//  Created by Eneko Alonso on 10/5/17.
//

import XCTest
import ProcessRunner

class VersionCommandTests: XCTestCase {

    func testVersion() throws {
        let result = try system(command: binaryURL.path, parameters: ["version"], captureOutput: true)
        XCTAssertEqual(result.standardOutput, "SourceDocs v1.2.1")
    }

}
