//
//  GenerateCommandTests.swift
//  
//
//  Created by Eneko Alonso on 11/2/19.
//

import XCTest
import System

class GenerateCommandTests: XCTestCase {

    func testMinimumAccessLevelParameter() throws {
        try system(command: "pwd")
    }

}
