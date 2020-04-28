//
//  AccessLevels.swift
//  
//
//  Created by Eneko Alonso on 4/27/20.
//

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
