//
//  SampleCode.swift
//  sourcedocs
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation

/// Describes an animal hierarchy of things
public protocol Animal {
    /// Print a greeting message
    func speak()
}

/// Describes a thing that can be named
public protocol Nameable: CustomStringConvertible {
    /// Name of the thing being named
    var name: String { get }
}

extension Nameable {
    /// Describes a named thing
    public var description: String {
        return "Hello, my name is \(name)."
    }
}

/// Describes an entity that can "speak"
public protocol Speaker {
    /// Print a greeting message
    func speak()
}

/// Common animal many people have as pet
public struct Dog: Animal, Nameable {
    /// All dogs should have a name
    public let name: String
}

extension Dog: Speaker {
    /// Dogs know how to speak!
    public func speak() {
        print("Woof, woof!")
    }
}
