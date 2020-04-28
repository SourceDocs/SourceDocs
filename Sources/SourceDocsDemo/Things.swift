//
//  Things.swift
//  
//
//  Created by Eneko Alonso on 4/27/20.
//

import Foundation

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
