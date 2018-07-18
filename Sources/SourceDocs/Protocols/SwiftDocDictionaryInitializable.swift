//
//  SwiftDocDictionaryInitializable.swift
//  SourceDocs
//
//  Created by xs19on on 18/07/2018.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

protocol SwiftDocDictionaryInitializable {
    var dictionary: SwiftDocDictionary { get }

    init?(dictionary: SwiftDocDictionary)
}

private enum SwiftDocDiscussionKey: String {
    case attention = "Attention"
    case author = "Author"
    case authors = "Authors"
    case bug = "Bug"
    case complexity = "Complexity"
    case copyright = "Copyright"
    case date = "Date"
    case example = "Example"
    case experiment = "Experiment"
    case important = "Important"
    case invariant = "Invariant"
    case note = "Note"
    case precondition = "Precondition"
    case postcondition = "Postcondition"
    case remark = "Remark"
    case requires = "Requires"
    case seeAlso = "SeeAlso"
    case since = "Since"
    case version = "Version"
    case warning = "Warning"

    case paragraph = "Para"
    case codeListing = "CodeListing"

    static var calloutKeys: [SwiftDocDiscussionKey] {
        return [ .attention, .author, .authors, .bug, .complexity, .copyright, .date, .example, .experiment, .important, .invariant, .note, .precondition, .postcondition, .remark, .requires, .seeAlso, .since, .version, .warning ]
    }

    static var all: [SwiftDocDiscussionKey] {
        return calloutKeys + [ .paragraph, .codeListing ]
    }
}

extension SwiftDocDictionaryInitializable {

    // MARK: - Public Properties

    var name: String {
        return dictionary.get(.name) ?? "[NO NAME]"
    }

    var comment: String {
        return abstract + discussion + callouts
    }

    var declaration: String {
        let declaration: String = dictionary.get(.docDeclaration) ?? dictionary.get(.parsedDeclaration) ?? ""

        guard declaration.isEmpty else {
            return MarkdownCodeBlock(code: declaration, style: .backticks(language: "swift")).markdown
        }

        guard let parseDeclaration: String = dictionary.get(.parsedDeclaration) else {
            return ""
        }
        return MarkdownCodeBlock(code: parseDeclaration, style: .backticks(language: "swift")).markdown

    }

    var debugInfo: [String: Any] {
        let file = (dictionary.get(.filePath) ?? "").replacingOccurrences(of: FileManager.default.currentDirectoryPath, with: "")

        return [
            "name": name,
            "declaration": dictionary.get(.parsedDeclaration) ?? "",
            "file": file,
            "isDocumented": !comment.isEmpty
        ]
    }

    // MARK: - Private Properties

    private var abstract: String {
        guard let text: String = dictionary.get(.docAbstract) else {
            return ""
        }
        return text + "\n\n"
    }

    private var discussion: String {
        guard let xmlString: String = dictionary.get(.docDiscussionXML) else {
            return ""
        }

        guard let xml = try? XMLDocument(xmlString: xmlString, options: XMLNode.Options.documentTidyXML),
            let children = xml.children?.first?.children else {
                return ""
        }

        return children.compactMap { (node) -> String? in
            guard SwiftDocDiscussionKey.all.contains(where: { (key) -> Bool in return key.rawValue == node.name }) else {
                return node.description
            }

            /// Handle code
            if node.name == SwiftDocDiscussionKey.codeListing.rawValue, let code = node.children?.compactMap({ $0.stringValue?.isEmpty ?? true ? nil : $0.stringValue }).joined(separator: "\n") {
                return "```\n\(code)\n```"
            }

            guard let element = node.children?.first as? XMLElement, let elementName = element.name else {
                return node.stringValue
            }

            if elementName == "Link", let text = node.stringValue, let url = element.attribute(forName: "href")?.stringValue {
                return "[\(text)](\(url))"
            }

            if elementName == "img", let url = element.attribute(forName: "src")?.stringValue {
                let text = element.attribute(forName: "atl")?.stringValue ?? ""
                return "![\(text)](\(url))"
            }

            return nil
            }.joined(separator: "\n\n")
    }

    private var callouts: String {
        let callouts = SwiftDocDiscussionKey.calloutKeys.reduce("\n\n") { (string, key) -> String in
            var string = string
            if let text = paragraph(for: key), !text.isEmpty {
                string += "\n\n\(MarkdownCollapsibleSection(summary: key.rawValue, details: text).markdown)\n\n"
            }
            return string
        }
        return callouts.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" : callouts
    }

    // MARK: - Public

    func collectionOutput(title: String, collection: [MarkdownConvertible]) -> String {
        return collection.isEmpty ? "" : """
        \(title)
        \(collection.markdown)
        """
    }

    // MARK: - Private

    private func paragraph(for key: SwiftDocDiscussionKey) -> String? {
        var keyFound = false
        var string = ""

        guard let discussions: [[String: String]] = dictionary.get(.docDiscussion) else {
            return string
        }

        for discussion in discussions {
            let isKey = discussion.first?.key == key.rawValue
            let isParagraph = discussion.first?.key == SwiftDocDiscussionKey.paragraph.rawValue

            if isKey && !keyFound {
                keyFound = true

                if let value = discussion.first?.value {
                    string = "\n\n" + value
                } else {
                    string = ""
                }
            } else if isParagraph && keyFound {
                string += "\n\n" + (discussion.first?.value ?? "")
            } else if !isKey && !isParagraph && keyFound {
                break
            }
        }

        return string.isEmpty ? nil : string
    }
}
