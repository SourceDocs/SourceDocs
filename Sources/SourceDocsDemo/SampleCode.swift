//
//  SampleCode.swift
//  sourcedocs
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation

/// Describes an animal hierarchy of things
///
/// This could be big
///
/// might be many
///
/// many
///
///
/// - Attention:  Blah blah blah
///
/// many comments here.
///
/// Test Test TEst
/// - Author:  Blah blah blah
/// - Authors:  Blah blah blah
/// - Bug:  Blah blah blah
/// - Complexity:  Blah blah blah
/// - Copyright:  Blah blah blah
/// - CustomCallout:  Blah blah blah
/// - Date:  Blah blah blah
/// - Example:  Blah blah blah
/// - Experiment:  Blah blah blah
/// - Important:  Blah blah blah
/// - Invariant:  Blah blah blah
/// - Note:  Blah blah blah
/// - Precondition:  Blah blah blah
/// - Postcondition:  Blah blah blah
/// - Remark:  Blah blah blah
/// - Requires:  Blah blah blah
/// - SeeAlso:  Blah blah blah
/// - Since:  Blah blah blah
/// - Version:  Blah blah blah
/// - Warning:  Blah blah blah
public protocol Animal {
    /// Print a greeting message
    func greet()

    /// All animals belong to a family
    static var family: String { get }
}

/// Describes the state of domestication
///
/// - domesticated: For animal that are domesticated.
/// - undomesticated: For animal that are not domesticated.
/// - unknown: For animals which have an unknown domestication state.
public enum DomesticationState {
    /// For animal that are domesticated.
    case domesticated
    /// For animal that are not domesticated.
    case undomesticated
    /// For animals which have an unknown domestication state.
    case unknown
}

/// Describes a thing that can be named
public protocol Nameable: CustomStringConvertible {
    /// Name of the thing being named
    var name: String { get }
}

extension Nameable {
    /// Describes a named thing
    public var description: String {
        DomesticationState.domesticated
        return "Hello, my name is \(name)."
    }
}

/// Describes an entity that can "speak"
///
/// ## Cool noises
/// moo, woof, yap, meow, squawk, etc
///
/// - Note: Name must be fun!
/// - Warning: Nyan Nyan Nyan Nyan Nyan
public protocol Speaker {
    /// Print a greeting message
    func speak()
}

/// Common animal many people have as pet
///
/// ![Look at this dog](https://media.giphy.com/media/mCRJDo24UvJMA/giphy.gif)
public struct Dog: Animal, Nameable {
    /// All dogs should have a name
    public let name: String

    /// All dogs are canines
    public static let family = "Canidae"

    public func greet() {
        print("Nice to meet you.")
    }
}

extension Dog: Speaker {
    /// Dogs know how to speak!
    public func speak() {
        print("Woof, woof!")
    }
}

/// Common animal many people have as pets, which is not a dog
///
/// ![The real head of the household?](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)
open class Cat: Animal, Nameable {
    /// All cats should have a name too
    public let name: String

    /// Some cats have an owner
    public var owner: String?

    /// All cats are felines
    public static let family = "Felidae"

    /// Initialize a new Cat with an name and an owner's name
    ///
    /// - Parameters:
    ///   - name: The name of the cat.
    ///   - owner: The cat's owners name.
    /// - Note: Name must be fun!
    /// - Warning: Nyan Nyan Nyan Nyan Nyan
    public init(name: String, owner: String?) {
        self.name = name
        self.owner = owner
    }

    public func greet() {
        print("ew people.")
    }
}

extension Cat: Speaker {
    /// Cats know how to speak!!!
    public func speak() {
        print("Meow")
    }
}
