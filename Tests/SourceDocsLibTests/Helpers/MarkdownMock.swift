import Foundation
@testable import SourceDocsLib

struct MarkdownMock: SwiftDocDictionaryInitializable {
    let dictionary: SwiftDocDictionary

    init(dictionary: SwiftDocDictionary) {
        self.dictionary = dictionary
    }
}
