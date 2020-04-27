import XCTest

import SourceDocsCLITests
import SourceDocsLibTests

var tests = [XCTestCaseEntry]()
tests += SourceDocsCLITests.__allTests()
tests += SourceDocsLibTests.__allTests()

XCTMain(tests)
