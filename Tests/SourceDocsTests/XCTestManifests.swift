import XCTest

extension SwiftDocDictionaryTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftDocDictionaryTests.__allTests),
    ]
}
#endif
