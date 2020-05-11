//
//  SourceDocsError.swift
//  
//
//  Created by Eneko Alonso on 5/10/20.
//

import XCTest
import SourceDocsLib

class SourceDocsErrorTests: XCTestCase {

    func testErrorMessage() {
        XCTAssertEqual(SourceDocsError.internalError(message: "Foo Bar").localizedDescription, "Foo Bar")
    }
}
