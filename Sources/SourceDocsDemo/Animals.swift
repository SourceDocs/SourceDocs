//
//  Animals.swift
//  
//
//  Created by Eneko Alonso on 4/27/20.
//

import Foundation

/// Six major groups of animals
public enum AnimalKind {
    case invertebrate
    case fish
    case amphibian
    case reptile
    case bird
    case mammal
}

public protocol Animal: LivingThing, Aging {
    var kind: AnimalKind { get }
}

/// All pets should have a name, and an owner
public protocol Pet: Animal, Nameable, OwnableAnimal {}

/// Common animal many people have as pet
public struct Dog: Pet {
    public var kind = AnimalKind.mammal
    public var isAlive = true
    public var owner: AnimalOwner?

    /// All dogs should have a name
    public let givenName: String
    public var age: UInt
}

extension Dog: Speaker {
    /// Dogs know how to speak!
    public func speak() -> String {
        return "Woof, woof!"
    }
}

public protocol OwnableAnimal {
    var owner: AnimalOwner? { get set }
}
