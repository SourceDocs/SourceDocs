//
//  SampleCode.swift
//  sourcedocs
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation

/// Describes an animal hierarchy of things
///
/// - Attention: Attention Callout Example
/// - Author: Author Callout Example
/// - Authors: Authors Callout Example
/// - Bug: Bug Callout Example
/// - Complexity: Complexity Callout Example
/// - Copyright: Copyright Callout Example
/// - CustomCallout: CustomCallout Callout Example. CustomCallout is not supported! The will appear as bullet lists.
/// - Date: Date Callout Example
/// - Example: Example Callout Example
/// - Experiment: Experiment Callout Example
/// - Important: Important Callout Example
/// - Invariant: Invariant Callout Example
/// - Note: Note Callout Example
/// - Precondition: Precondition Callout Example
/// - Postcondition: Postcondition Callout Example
/// - Remark: Remark Callout Example
/// - Requires: Requires Callout Example
/// - SeeAlso: SeeAlso Callout Example
/// - Since: Since Callout Example
/// - Version: Version Callout Example
/// - Warning: Warning Callout Example
public protocol Animal {
    /// Print a greeting message
    func greet()

    /// All animals belong to a family
    static var family: String { get }
}

/// Describes the state of domestication
///
/// ### h3 _this is italics_
///
/// # h1 **this is bold**
///
/// ## h2 WHAT
///
/// ###### h6
/// ---
/// ***
/// - domesticated: For animal that are domesticated.
/// - undomesticated: For animal that are not domesticated.
/// - unknown: For animals which have an unknown domestication state.
///
/// Here is a comment with [link that is](http://www.link.com) embedded
///
/// ![dog gif](https://media.giphy.com/media/mCRJDo24UvJMA/giphy.gif)
public enum DomesticationState {
    /// For animal that are domesticated.
    case domesticated
    /// For animal that are not domesticated.
    case undomesticated
    /// For animals which have an unknown domestication state.
    case unknown(String)
}

@objc
@available(swift, obsoleted: 1.0)
public class ObjcOnlyClass: NSObject {

}

@objc
@available(swift, obsoleted: 1.0)
public protocol ObjcOnlyProtocol {

}

/// Describes a thing that can be named
/// 1. one
/// 1. two
/// 1. three
///
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
///
/// [google it](http://www.google.com)
///
/// ```html
///     <html>
///         <body>
///
///             <h1>My First Heading</h1>
///
///             <p>My first paragraph.</p>
///
///         </body>
///     </html>
/// ```
///
/// ```
/// var unspecifiedLanguagueVar = 1
/// ```
///
/// ```swift
///     let swiftyConstant = 1
/// ```
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

    @objc
    @available(swift, obsoleted: 1.0)
    public func obsoletedGreet() {
        print("ew people.")
    }
}

extension Cat: Speaker {
    /// Cats know how to speak!!!
    public func speak() {
        print("Meow")
    }
}
