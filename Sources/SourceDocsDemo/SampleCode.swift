//
//  SampleCode.swift
//  sourcedocs
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation

/// Global method should be documented
///
/// - Parameters:
///   - param1: some string parameter
///   - param2: some int parameter
/// - Returns: decimal value
/// - Throws: might never throw, right?
public func globalMethod(param1: String, param2: Int) throws -> Decimal {
    return 42
}

// MARK: - Protocols and Extensions

/// Describes an animal hierarchy of things
public protocol LivingThing {
    /// Determines if the animal is alive or not
    var isAlive: Bool { get set }
}

/// Defines something that ages with time
public protocol Aging {
    /// Determines thel age in years
    var age: UInt { get set }
}

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

/// Describes a thing that can be named
public protocol Nameable: CustomStringConvertible {
    /// Name of the thing being named
    var givenName: String { get }
}

extension Nameable {
    /// Describes a named thing
    public var description: String {
        return "My name is \(givenName)."
    }
}

extension Nameable {
    /// Alternative description for a thing
    public var alternateDescription: String {
        return "People call me \(givenName)."
    }
}

/// Describes an entity that can "speak"
public protocol Speaker {
    /// Print a greeting message
    func speak()
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
    public func speak() {
        print("Woof, woof!")
    }
}

public protocol OwnableAnimal {
    var owner: AnimalOwner? { get set }
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
open class Person: Human {
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
    public mutating func acquire(animal: inout OwnableAnimal) {
        animal.owner = self
        animals.append(animal)
    }
}

// MARK: - Nested Types

public struct Foo {
    public struct Bar {
        public enum Baz {
            case foo
            case bar
            case baz
        }
    }
}

extension Foo {
    public var foo: Foo.Bar.Baz { Bar.Baz.foo }
}

extension Foo.Bar {
    public var bar: Foo.Bar.Baz { Baz.bar }
}

extension Foo.Bar.Baz {
    public var baz: Foo.Bar.Baz { .baz }
}

// MARK: - ACL tests

/// A class to test documentation of different access levels
/// - By default, only `open` and `public` ACL are documented
/// - Use `--min-acl` to specify different levels of ACL to be documented:
///   - `--min-acl private` will document `private`, `fileprivate`, `internal`, `public`, & `open`
///   - `--min-acl fileprivate` will document `fileprivate`, `internal`, `public`, & `open`
///   - `--min-acl internal` will document `internal`, `public`, & `open`
///   - `--min-acl public` will document `public`, & `open`
///   - `--min-acl open` will document `open`
open class ACLTestClass {

    /// Method with `open` access level
    open func openMethod() {
        //
    }

    /// Method with `public` access level
    public func publicMethod() {
        //
    }

    /// Method with implicit `internal` access level
    func implicitInternalMethod() {
        //
    }

    /// Method with explicit `internal` access level
    internal func explicitInternalMethod() {
        //
    }

    /// Method with explicit `fileprivate` access level
    fileprivate func filePrivateMethod() {
        //
    }

    /// Method with explicit `private` access level
    private func privateMethod() {
        //
    }
}
