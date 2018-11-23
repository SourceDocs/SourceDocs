import XCTest

extension VersionCommandTests {
    static let __allTests = [
        ("testVersion", testVersion),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(VersionCommandTests.__allTests),
    ]
}
#endif
