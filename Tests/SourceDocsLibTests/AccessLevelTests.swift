//
//  AccessLevelTests.swift
//  SourceDocsLibTests
//
//  Created by Eneko Alonso on 11/1/19.
//

import XCTest
@testable import SourceDocsLib

class AccessLevelTests: XCTestCase {

    func testLevels() {
        let levels = AccessLevel.allCases
        XCTAssertEqual(levels.count, 5)
    }

    func testOrdering() {
        XCTAssertGreaterThan(AccessLevel.fileprivate.priority, AccessLevel.private.priority)
        XCTAssertGreaterThan(AccessLevel.internal.priority, AccessLevel.fileprivate.priority)
        XCTAssertGreaterThan(AccessLevel.public.priority, AccessLevel.internal.priority)
        XCTAssertGreaterThan(AccessLevel.open.priority, AccessLevel.public.priority)
    }

    func testAccessibilityKey() {
        XCTAssertEqual(AccessLevel(accessiblityKey: nil), .private)
        XCTAssertEqual(AccessLevel(accessiblityKey: ""), .private)
        XCTAssertEqual(AccessLevel(accessiblityKey: "Foo Bar"), .private)
        XCTAssertEqual(AccessLevel(accessiblityKey: "source.lang.swift.accessibility.private"), .private)
        XCTAssertEqual(AccessLevel(accessiblityKey: "source.lang.swift.accessibility.fileprivate"), .fileprivate)
        XCTAssertEqual(AccessLevel(accessiblityKey: "source.lang.swift.accessibility.internal"), .internal)
        XCTAssertEqual(AccessLevel(accessiblityKey: "source.lang.swift.accessibility.public"), .public)
        XCTAssertEqual(AccessLevel(accessiblityKey: "source.lang.swift.accessibility.open"), .open)
    }

}
