//
//  ClassesTests.swift
//  SourceDocsTests
//
//  Created by Eneko Alonso on 8/13/19.
//

import XCTest

class ClassesTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        generateDocumentation()
    }

    func testOpenKeyword() throws {
        let filename = "\(documentationPath)/SourceDocsDemo/classes/OpenClassFoo.md"
        XCTAssertTrue(FileManager.default.fileExists(atPath: filename))

        let content = try String(contentsOfFile: filename)
        let expectation = """
            **CLASS**

            # `OpenClassFoo`

            ```swift
            open class OpenClassFoo
            ```

            > A simple class to test open access level

            ## Methods
            ### `sayHello()`

            ```swift
            open func sayHello()
            ```

            > Prints hello

            ### `sayGoodBye()`

            ```swift
            public func sayGoodBye()
            ```

            > Prints good bye

            """
        XCTAssertEqual(content, expectation)
    }

}
