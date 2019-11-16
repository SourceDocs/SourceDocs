//
//  GenerateCommandTests.swift
//  
//
//  Created by Eneko Alonso on 11/2/19.
//

import XCTest
import Basic
import System

class GenerateCommandTests: XCTestCase {

    static let subjectsPath = "Tests/Subjects"

    static override func setUp() {
        super.setUp()
        _ = try? system(shell: "cd \(subjectsPath) && swift build")
    }

    static override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(atPath: "Documentation")
        try? FileManager.default.removeItem(atPath: "Temp")
    }

    func testDefault() throws {
        let result = try generateDocs(parameters: "")
        XCTAssertEqual(result.standardOutput, "")
        XCTAssertTrue(result.standardError.contains("xcodebuild: error: Unknown build action"))
    }

    func testDefaultSourceDocsDemo() throws {
        let result = try generateDocs(parameters: "--spm-module", "SourceDocsDemo")
        XCTAssertTrue(result.standardOutput.hasPrefix("Generating Markdown documentation..."))
        XCTAssertTrue(result.standardOutput.hasSuffix("Done 🎉"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/README.md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/classes/ACLTestClass.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/classes/Person.md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/enums/AnimalKind.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/enums/Baz.md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/AnimalOwner.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/Dog.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/Foo.Bar.Baz.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/Foo.Bar.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/Foo.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/extensions/Nameable.md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/methods/globalMethod(param1:param2:).md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Aging.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Animal.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/AnimalOwner.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Human.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/LivingThing.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Nameable.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/OwnableAnimal.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Pet.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/protocols/Speaker.md"))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/structs/Bar.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/structs/Dog.md"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Documentation/Reference/structs/Foo.md"))
    }

    func testPublicClass() throws {
        let result = try generateDocs(parameters: "--spm-module", "PublicClass",
                                      "--input-folder", Self.subjectsPath,
                                      "--output-folder", "Temp/Docs", "-m")
        XCTAssertTrue(result.standardOutput.hasSuffix("Done 🎉"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Temp/Docs/PublicClass/README.md"))

        let contents = try String(contentsOfFile: "Temp/Docs/PublicClass/classes/Foo.md")
        XCTAssertTrue(contents.contains("This is a public class named Foo"))
        XCTAssertTrue(contents.contains("public class Foo"))
        XCTAssertTrue(contents.contains("This is a public method on a public class"))
        XCTAssertTrue(contents.contains("public func publicMethod()"))
        XCTAssertFalse(contents.contains("This is an internal method on a public class"))
        XCTAssertFalse(contents.contains("func internalMethod()"))
        XCTAssertFalse(contents.contains("This is a fileprivate method on a public class"))
        XCTAssertFalse(contents.contains("fileprivate func filePrivateMethod()"))
        XCTAssertFalse(contents.contains("This is a private method on a public class"))
        XCTAssertFalse(contents.contains("private func privateMethod()"))
    }

    func testPublicClassWithInternalACL() throws {
        let result = try generateDocs(parameters: "--spm-module", "PublicClass",
                                      "--input-folder", Self.subjectsPath,
                                      "--output-folder", "Temp/Docs", "-m",
                                      "--min-acl", "internal")
        XCTAssertTrue(result.standardOutput.hasSuffix("Done 🎉"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Temp/Docs/PublicClass/README.md"))

        let contents = try String(contentsOfFile: "Temp/Docs/PublicClass/classes/Foo.md")
        XCTAssertTrue(contents.contains("This is a public class named Foo"))
        XCTAssertTrue(contents.contains("public class Foo"))
        XCTAssertTrue(contents.contains("This is a public method on a public class"))
        XCTAssertTrue(contents.contains("public func publicMethod()"))
        XCTAssertTrue(contents.contains("This is an internal method on a public class"))
        XCTAssertTrue(contents.contains("func internalMethod()"))
        XCTAssertFalse(contents.contains("This is a fileprivate method on a public class"))
        XCTAssertFalse(contents.contains("fileprivate func filePrivateMethod()"))
        XCTAssertFalse(contents.contains("This is a private method on a public class"))
        XCTAssertFalse(contents.contains("private func privateMethod()"))
    }

    func testPublicClassWithFilePrivateACL() throws {
        let result = try generateDocs(parameters: "--spm-module", "PublicClass",
                                      "--input-folder", Self.subjectsPath,
                                      "--output-folder", "Temp/Docs", "-m",
                                      "--min-acl", "fileprivate")
        XCTAssertTrue(result.standardOutput.hasSuffix("Done 🎉"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Temp/Docs/PublicClass/README.md"))

        let contents = try String(contentsOfFile: "Temp/Docs/PublicClass/classes/Foo.md")
        XCTAssertTrue(contents.contains("This is a public class named Foo"))
        XCTAssertTrue(contents.contains("public class Foo"))
        XCTAssertTrue(contents.contains("This is a public method on a public class"))
        XCTAssertTrue(contents.contains("public func publicMethod()"))
        XCTAssertTrue(contents.contains("This is an internal method on a public class"))
        XCTAssertTrue(contents.contains("func internalMethod()"))
        XCTAssertTrue(contents.contains("This is a fileprivate method on a public class"))
        XCTAssertTrue(contents.contains("fileprivate func filePrivateMethod()"))
        XCTAssertFalse(contents.contains("This is a private method on a public class"))
        XCTAssertFalse(contents.contains("private func privateMethod()"))
    }

    func testPublicClassWithPrivateACL() throws {
        let result = try generateDocs(parameters: "--spm-module", "PublicClass",
                                      "--input-folder", Self.subjectsPath,
                                      "--output-folder", "Temp/Docs", "-m",
                                      "--min-acl", "private")
        XCTAssertTrue(result.standardOutput.hasSuffix("Done 🎉"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: "Temp/Docs/PublicClass/README.md"))

        let contents = try String(contentsOfFile: "Temp/Docs/PublicClass/classes/Foo.md")
        XCTAssertTrue(contents.contains("This is a public class named Foo"))
        XCTAssertTrue(contents.contains("public class Foo"))
        XCTAssertTrue(contents.contains("This is a public method on a public class"))
        XCTAssertTrue(contents.contains("public func publicMethod()"))
        XCTAssertTrue(contents.contains("This is an internal method on a public class"))
        XCTAssertTrue(contents.contains("func internalMethod()"))
        XCTAssertTrue(contents.contains("This is a fileprivate method on a public class"))
        XCTAssertTrue(contents.contains("fileprivate func filePrivateMethod()"))
        XCTAssertTrue(contents.contains("This is a private method on a public class"))
        XCTAssertTrue(contents.contains("private func privateMethod()"))
    }

    private func generateDocs(parameters: String...) throws -> ProcessResult {
        let params = ["generate"] + parameters
        return try system(command: binaryURL.path, parameters: params, captureOutput: true)
    }
}
