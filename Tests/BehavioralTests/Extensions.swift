//
//  Extensions.swift
//  
//
//  Created by Eneko Alonso on 11/2/19.
//

import XCTest

extension XCTestCase {
    /// Path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }

    /// Path to binary executable.
    var binaryURL: URL {
        productsDirectory.appendingPathComponent("sourcedocs")
    }

}
