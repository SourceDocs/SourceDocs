import Foundation

/// Custom keys used by sourcedocs that are added to the SwiftDocDictionary
enum SourceDocsKey: String {
    case parentNames = "key.sourcedocs.parent_names"
}

extension SwiftDocDictionary {
    /// Convenient accessor
    subscript<T>(key: SourceDocsKey) -> T? {
        get { self[key.rawValue] as? T }
        set { self[key.rawValue] = newValue }
    }

    /// Safe tipe accessor for the parent names
    var parentNames: [String] {
        get { self[.parentNames] ?? [] }
        set { self[.parentNames] = newValue }
    }
}
