//
//  SwiftDocDictionaryInitializable.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 18/07/2018.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

protocol SwiftDocDictionaryInitializable {
    var dictionary: SwiftDocDictionary { get }

    init?(dictionary: SwiftDocDictionary)
}

private struct RegularExpression {
    static let codeVoice = try! NSRegularExpression(pattern: "</?codeVoice>", options: NSRegularExpression.Options.caseInsensitive)
    static let emphasis = try! NSRegularExpression(pattern: "</?emphasis>", options: NSRegularExpression.Options.caseInsensitive)
    static let img = try! NSRegularExpression(pattern: "<rawHTML><!\\[CDATA\\[<img\\s*src=\"(.*?)\"\\s*(?:alt=\"(.*?)\")?\\/>\\]\\]><\\/rawHTML>", options: .allowCommentsAndWhitespace)
    static let link = try! NSRegularExpression(pattern: "<Link\\s*href=\"(.*?)\">(.*?)<\\/Link>", options: .allowCommentsAndWhitespace)
    static let bold = try! NSRegularExpression(pattern: "</?bold>", options: NSRegularExpression.Options.caseInsensitive)
    static let horizontalRule = try! NSRegularExpression(pattern: "<rawHTML><!\\[CDATA\\[<hr\\/>\\]\\]><\\/rawHTML>", options: NSRegularExpression.Options.caseInsensitive)
    static let openingHeaderTag = try! NSRegularExpression(pattern: "<rawHTML><!\\[CDATA\\[<h(\\d)>\\]\\]><\\/rawHTML>", options: NSRegularExpression.Options.caseInsensitive)
    static let closingHeaderTag = try! NSRegularExpression(pattern: "<rawHTML><!\\[CDATA\\[<\\/h\\d>\\]\\]><\\/rawHTML>", options: NSRegularExpression.Options.caseInsensitive)
}

extension SwiftDocDictionaryInitializable {

    // MARK: - Public Properties

    var name: String {
        return dictionary.get(.name) ?? "[NO NAME]"
    }

    var comment: String {
        return [abstract, discussion, callouts].compactMap({$0}).joined(separator: "\n")
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

    private var abstract: String? {
        guard let text: String = dictionary.get(.docAbstract) else {
            return nil
        }
        return text
    }

    private var discussion: String? {
        guard var xmlString: String = dictionary.get(.fullXMLDocs) else {
            return nil
        }
        
        xmlString.replacingMatches(RegularExpression.bold, with: "__")
        xmlString.replacingMatches(RegularExpression.codeVoice, with: "`")
        xmlString.replacingMatches(RegularExpression.emphasis, with: "_")
        xmlString.replacingMatches(RegularExpression.horizontalRule, with: "---\n")
        xmlString.replacingMatches(RegularExpression.closingHeaderTag, with: "\n")
        xmlString.replacingMatches(RegularExpression.img, with: "![$2]($1)")
        xmlString.replacingMatches(RegularExpression.link, with: "[$2]($1)")
        
        /// Replace all opening header tags with the cooresponding number of #'s
        (1...6).forEach {
            let headerOpeningTag = "<rawHTML><![CDATA[<h\($0)>]]></rawHTML>"
            let replacement = String(repeating: "#", count: $0) + " "
            xmlString = xmlString.replacingOccurrences(of: headerOpeningTag, with: replacement)
        }

        guard let xml = try? XMLDocument(xmlString: xmlString, options: XMLNode.Options.nodePreserveAll),
            let documentationNodes = try? xml.nodes(forXPath: "//CommentParts//Discussion").first,
            let children = documentationNodes?.children else {
                return nil
        }

        return children.compactMap { (node) -> String? in
            /// Check that the node is a known key. It could be that the old XML was stripped.
            guard SwiftDocDiscussionKey.isDiscussionKey(node.name) else {
                return node.stringValue
            }

            /// Handle code
            if node.name == SwiftDocDiscussionKey.codeListing.rawValue {
                guard let element = node as? XMLElement else {
                    return node.stringValue
                }

                let language = element.attribute(forName: "language")?.stringValue ?? ""

                guard let code = element.children?.compactMap({ $0.stringValue }).joined(separator: "\n") else {
                    return element.stringValue
                }
                return "```\(language)\n\(code)```"
            }

            /// Handle bullet lists
            if node.name == SwiftDocDiscussionKey.listBullet.rawValue {
                return node.children?.compactMap({
                    guard let stringValue = $0.stringValue, !stringValue.isEmpty else { return nil }
                    return "- \(stringValue)"
                }).joined(separator: "\n")
            }
            
            /// Handle numbered lists
            if node.name == SwiftDocDiscussionKey.listNumber.rawValue {
                return node.children?.enumerated().compactMap({
                    let index = $0.0 + 1
                    guard let stringValue = $0.1.stringValue, !stringValue.isEmpty else { return nil }
                    return "\(index). \(stringValue)"
                }).joined(separator: "\n")
            }

            // The node is either a callout or we don't know how to parse it
            return SwiftDocDiscussionKey.isCalloutKey(node.name) ? nil : node.stringValue
            }.joined(separator: "\n\n")
    }

    private var callouts: String? {
        let callouts = SwiftDocDiscussionKey.calloutKeys.reduce("") { (string, key) -> String in
            var string = string
            if let text = paragraph(for: key), !text.isEmpty {
                string += "\n\n\(MarkdownCollapsibleSection(summary: key.rawValue, details: text).markdown)\n\n"
            }
            return string
        }
        return callouts.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : callouts
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
