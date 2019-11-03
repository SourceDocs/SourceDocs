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
