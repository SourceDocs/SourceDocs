//
//  SampleCode.swift
//
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

// swiftlint:disable nesting
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
