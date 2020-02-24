//
//  AccessLevelTests.swift
//  
//
//  Created by Eneko Alonso on 11/1/19.
//

import XCTest
 import SourceDocsLib

class AccessLevelTests: XCTestCase {

    func testPriority() {
        let levels = AccessLevel.allCases
        XCTAssertEqual(levels.count, 5)
    }
}
