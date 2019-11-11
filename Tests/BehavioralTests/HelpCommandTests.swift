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

        XCTAssertTrue(result.standardOutput.contains("clean"))
        XCTAssertTrue(result.standardOutput.contains("Delete the output folder and quit."))

        XCTAssertTrue(result.standardOutput.contains("generate"))
        XCTAssertTrue(result.standardOutput.contains("Generates the Markdown documentation"))

        XCTAssertTrue(result.standardOutput.contains("help"))
        XCTAssertTrue(result.standardOutput.contains("Display general or command-specific help"))

        XCTAssertTrue(result.standardOutput.contains("version"))
        XCTAssertTrue(result.standardOutput.contains("Display the current version of SourceDocs"))
    }

    func testHelpClean() throws {
        let result = try system(command: binaryURL.path, "help", "clean", captureOutput: true)
        XCTAssertTrue(result.standardOutput.contains("Delete the output folder and quit."))

        XCTAssertTrue(result.standardOutput.contains("--output-folder"))
        XCTAssertTrue(result.standardOutput.contains("Output directory (defaults to Documentation/Reference)."))
    }

    func testHelpGenerate() throws {
        let result = try system(command: binaryURL.path, "help", "generate", captureOutput: true)
        XCTAssertTrue(result.standardOutput.contains("Generates the Markdown documentation"))

        XCTAssertTrue(result.standardOutput.contains("[--spm-module (string)]"))
        XCTAssertTrue(result.standardOutput.contains("Generate documentation for Swift Package Manager module."))

        XCTAssertTrue(result.standardOutput.contains("[--module-name (string)]"))
        XCTAssertTrue(result.standardOutput.contains("Generate documentation for a Swift module."))

        XCTAssertTrue(result.standardOutput.contains("[--link-beginning (string)]"))
        XCTAssertTrue(result.standardOutput.contains("The text to begin links with. Defaults to an empty string."))

        XCTAssertTrue(result.standardOutput.contains("[--link-ending (string)]"))
        XCTAssertTrue(result.standardOutput.contains("The text to end links with. Defaults to .md."))

        XCTAssertTrue(result.standardOutput.contains("[--input-folder (string)]"))
        XCTAssertTrue(result.standardOutput.contains("Path to the input directory (defaults to /Users/ramses.alonso/Development/eneko/SourceDocs)."))

        XCTAssertTrue(result.standardOutput.contains("[--output-folder (string)]"))
        XCTAssertTrue(result.standardOutput.contains("Output directory (defaults to Documentation/Reference)."))

        XCTAssertTrue(result.standardOutput.contains("[--min-acl (string)]"))
        XCTAssertTrue(result.standardOutput.contains("The minimum access level to generate documentation. Defaults to public."))

        XCTAssertTrue(result.standardOutput.contains("--module-name-path|-m"))
        XCTAssertTrue(result.standardOutput.contains("Include the module name as part of the output folder path."))

        XCTAssertTrue(result.standardOutput.contains("--clean|-c"))
        XCTAssertTrue(result.standardOutput.contains("Delete output folder before generating documentation."))

        XCTAssertTrue(result.standardOutput.contains("--collapsible|-l"))
        XCTAssertTrue(result.standardOutput.contains("Put methods, properties and enum cases inside collapsible blocks."))

        XCTAssertTrue(result.standardOutput.contains("--table-of-contents|-t"))
        XCTAssertTrue(result.standardOutput.contains("Generate a table of contents with properties and methods for each type."))

        XCTAssertTrue(result.standardOutput.contains("[[]]"))
        XCTAssertTrue(result.standardOutput.contains("List of arguments to pass to xcodebuild."))
    }

    func testHelpHelp() throws {
        let result = try system(command: binaryURL.path, "help", "help", captureOutput: true)
        XCTAssertTrue(result.standardOutput.contains("Display general or command-specific help"))

        XCTAssertTrue(result.standardOutput.contains("[(string)]"))
        XCTAssertTrue(result.standardOutput.contains("the command to display help for"))
    }

    func testHelpVersion() throws {
        let result = try system(command: binaryURL.path, "help", "version", captureOutput: true)
        XCTAssertTrue(result.standardOutput.contains("Display the current version of SourceDocs"))
    }
}
