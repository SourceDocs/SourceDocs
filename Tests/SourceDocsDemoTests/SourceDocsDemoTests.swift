//
//  SourceDocsDemoTests.swift
//  
//
//  Created by Eneko Alonso on 4/27/20.
//

import XCTest
@testable import SourceDocsDemo

/// These tests exist to ensure the code in SourceDocsDemo compiles and works as expected.
/// Other than that, these tests provide no value for SourceDocsLib or SourceDocsCLI.
class SourceDocsDemoTests: XCTestCase {

    func testOwnedAnimal() {
        var bob = Person(givenName: "Bob", familyName: "Jones")
        var lara = Dog(givenName: "Lara", age: 5)
        bob.acquire(animal: &lara)
        XCTAssertEqual(bob.animals.count, 1)
        XCTAssertEqual(lara.owner as? Person, bob)
    }

}

