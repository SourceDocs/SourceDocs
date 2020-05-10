//
//  FilenameTests.swift
//  
//
//  Created by Eneko Alonso on 5/10/20.
//

import XCTest
@testable import SourceDocsLib

class FilenameTests: XCTestCase {

    func testMethodFilename() throws {
        let dict: SwiftDocDictionary = [
            "key.accessibility": "source.lang.swift.accessibility.public",
            "key.kind": "source.lang.swift.decl.function.free",
            "key.name": "method(paramA:paramB:paramC:)"
        ]
        let options = MarkdownOptions(collapsibleBlocks: false, tableOfContents: false, minimumAccessLevel: .public)
        guard let method = MarkdownMethod(dictionary: dict, options: options) else {
            XCTFail("Expected method")
            return
        }
        let files = MarkdownIndex().makeFiles(with: [method], basePath: ".")
        XCTAssertEqual(files.first?.filePath, "./method(paramA_paramB_paramC_).md")
    }

}
