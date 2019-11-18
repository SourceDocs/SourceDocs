//
//  HelpCommandTests.swift
//  
//
//  Created by Eneko Alonso on 11/2/19.
//

import XCTest
import System

class HelpCommandTests: XCTestCase {

    func testHelp() throws {
        let result = try system(command: binaryURL.path, parameters: ["help"], captureOutput: true)
        let lines = [
            "clean",
            "Delete the output folder and quit.",
            "generate",
            "Generates the Markdown documentation",
            "help",
            "Display general or command-specific help",
            "version",
            "Display the current version of SourceDocs"
        ]
        lines.forEach { XCTAssertTrue(result.standardOutput.contains($0)) }
    }

    func testHelpClean() throws {
        let result = try system(command: binaryURL.path, "help", "clean", captureOutput: true)
        let lines = [
            "Delete the output folder and quit.",
            "--output-folder",
            "Output directory (defaults to Documentation/Reference)."
        ]
        lines.forEach { XCTAssertTrue(result.standardOutput.contains($0)) }
    }

    func testHelpGenerate() throws {
        let result = try system(command: binaryURL.path, "help", "generate", captureOutput: true)
        let lines = [
            "Generates the Markdown documentation",
            "[--spm-module (string)]",
            "Generate documentation for Swift Package Manager module.",
            "[--module-name (string)]",
            "Generate documentation for a Swift module.",
            "[--link-beginning (string)]",
            "The text to begin links with. Defaults to an empty string.",
            "[--link-ending (string)]",
            "The text to end links with. Defaults to .md.",
            "[--input-folder (string)]",
            "Path to the input directory (defaults to /Users/ramses.alonso/Development/eneko/SourceDocs).",
            "[--output-folder (string)]",
            "Output directory (defaults to Documentation/Reference).",
            "[--min-acl (string)]",
            "The minimum access level to generate documentation. Defaults to public.",
            "--module-name-path|-m",
            "Include the module name as part of the output folder path.",
            "--clean|-c",
            "Delete output folder before generating documentation.",
            "--collapsible|-l",
            "Put methods, properties and enum cases inside collapsible blocks.",
            "--table-of-contents|-t",
            "Generate a table of contents with properties and methods for each type.",
            "[[]]",
            "List of arguments to pass to xcodebuild."
        ]
        lines.forEach { XCTAssertTrue(result.standardOutput.contains($0)) }
    }

    func testHelpHelp() throws {
        let result = try system(command: binaryURL.path, "help", "help", captureOutput: true)
        let lines = [
            "Display general or command-specific help",
            "[(string)]",
            "the command to display help for"
        ]
        lines.forEach { XCTAssertTrue(result.standardOutput.contains($0)) }
    }

    func testHelpVersion() throws {
        let result = try system(command: binaryURL.path, "help", "version", captureOutput: true)
        let lines = [
            "Display the current version of SourceDocs"
        ]
        lines.forEach { XCTAssertTrue(result.standardOutput.contains($0)) }
    }
}
