//
//  SwiftDocDictionaryTests.swift
//  
//
//  Created by Eneko Alonso on 5/19/20.
//

import XCTest
import SourceKittenFramework
@testable import SourceDocsLib

class SwiftDocDictionaryTests: XCTestCase {

    let defaultOptions = MarkdownOptions(collapsibleBlocks: false, tableOfContents: false,
                                         minimumAccessLevel: .public)

    func testIsKind() {
        let dict: SwiftDocDictionary = [
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        XCTAssertTrue(dict.isKind(.functionFree), "Expected .functionFree")
    }

    func testIsNotKind() {
        let dict: SwiftDocDictionary = [:]
        XCTAssertFalse(dict.isKind(.functionFree), "Expected not to match")
    }

    func testIsOneOf() {
        let dict: SwiftDocDictionary = [
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        XCTAssertTrue(dict.isKind([.functionFree, .functionMethodClass]), "Expected match")
    }

    func testIsNotOneOf() {
        let dict: SwiftDocDictionary = [:]
        XCTAssertFalse(dict.isKind([.functionFree, .functionMethodClass]), "Expected match")
    }

    func testNoName() {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        XCTAssertEqual(method.name, "[NO NAME]", "Expected [NO NAME]")
    }

    func testComment() {
        let dict: SwiftDocDictionary = [
            "key.doc.comment": "Foo Bar",
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        XCTAssertEqual(method.comment, "Foo Bar", "Expected comment")
    }

    func testNoComment() {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        XCTAssertEqual(method.comment, "", "Expected no comment")
    }

    func testDeclaration() {
        let dict: SwiftDocDictionary = [
            "key.parsed_declaration": "Foo Bar",
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        let expectation = """
        ```swift
        Foo Bar
        ```
        """
        XCTAssertEqual(method.declaration, expectation, "Expected declaration")
    }

    func testNoDeclaration() {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        XCTAssertEqual(method.declaration, "", "Expected no declaration")
    }

    func testCollectionOutput() {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        let collection = ["Foo", "Bar", "Baz"]

        let expectation = """
        FooBar
        Foo

        Bar

        Baz
        """
        let output = method.collectionOutput(title: "FooBar", collection: collection)
        XCTAssertEqual(output, expectation, "Expected collection")
    }

    func testEmptyCollectionOutput() {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free"
        ]
        guard let method = MarkdownMethod(dictionary: dict, options: defaultOptions) else {
            XCTFail("Expected method")
            return
        }
        let output = method.collectionOutput(title: "FooBar", collection: [])
        XCTAssertEqual(output, "", "Expected empty output")
    }
}
