//
//  PackageCommandTests.swift
//  
//
//  Created by Eneko Alonso on 5/9/20.
//

import XCTest
import System

class PackageCommandTests: XCTestCase {

    func testCommand() throws {
        let baseURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let result = try system(command: binaryURL.path, parameters: ["package"],
                                captureOutput: true, currentDirectoryPath: baseURL.path)
        XCTAssertTrue(result.success, "Expected success")
    }

}
