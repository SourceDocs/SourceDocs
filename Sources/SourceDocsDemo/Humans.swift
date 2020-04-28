//
//  Humans.swift
//  
//
//  Created by Eneko Alonso on 4/27/20.
//

import Foundation

/// Describes an entity that can "speak"
public protocol Speaker {
    /// Print a greeting message
    func speak() -> String
}

public protocol AnimalOwner {
    /// Animal owners might have 0, 1 or more animals
    var animals: [OwnableAnimal] { get set }
}

/// Humans are mammals, age with time, and have a given name.
public protocol Human: Animal, Nameable, AnimalOwner {
    /// Most humans have a family name, but some do not.
    var familyName: String? { get }
}

/// All persons are humans.
open class Person: Human, Equatable {
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.givenName == rhs.givenName
            && lhs.familyName == rhs.familyName
            && lhs.age == rhs.age
            && lhs.isAlive == rhs.isAlive
    }

    open var kind: AnimalKind = .mammal
    open var isAlive: Bool
    open var age: UInt
    open var givenName: String
    open var familyName: String?
    open var animals: [OwnableAnimal] = []

    public init(givenName: String, familyName: String) {
        self.givenName = givenName
        self.familyName = familyName
        self.age = 0
        self.isAlive = true
    }
}

extension AnimalOwner {
    public mutating func acquire<Animal: OwnableAnimal>(animal: inout Animal) {
        animal.owner = self
        animals.append(animal)
    }
}
