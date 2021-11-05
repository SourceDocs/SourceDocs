//
//  HelpCommandTests.swift
//  SourceDocsCLITests
//
//  Created by Eneko Alonso on 11/2/19.
//

import XCTest
import ProcessRunner

class HelpCommandTests: XCTestCase {

    func testHelp() throws {
        let result = try system(command: binaryURL.path, parameters: ["help"], captureOutput: true)
        XCTAssertTrue(result.standardOutput.contains("clean"))
        XCTAssertTrue(result.standardOutput.contains("generate"))
        XCTAssertTrue(result.standardOutput.contains("help"))
        XCTAssertTrue(result.standardOutput.contains("version"))
    }

}
