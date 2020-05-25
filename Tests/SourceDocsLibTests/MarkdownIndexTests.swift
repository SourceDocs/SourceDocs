import Foundation
import XCTest
@testable import SourceDocsLib

class MarkdownIndexTests: XCTestCase {
    func testFooter() {
        let footer = DocumentationGenerator.generateFooter(reproducibleDocs: true)
        XCTAssertEqual(
            footer,
            """
            This reference documentation was generated with
            [SourceDocs](https://github.com/eneko/SourceDocs).
            """
        )
    }
}
