import XCTest

import BehavioralTests
import UnitTests

var tests = [XCTestCaseEntry]()
tests += BehavioralTests.__allTests()
tests += UnitTests.__allTests()

XCTMain(tests)
