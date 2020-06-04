//
//  GraphGenerator.swift
//
//
//  Created by Eneko Alonso on 5/7/20.
//

import Foundation
import System

protocol GraphGenerator {}

extension GraphGenerator {
    func generatePNG(input: URL, output: URL) throws {
        try system(command: "dot", "-Tpng", input.path, "-o", output.path)
    }

    func quoted(_ string: String) -> String {
        return "\"\(string)\""
    }
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation(indented string: String) {
        // swiftlint:disable:next compiler_protocol_init
        let indent = String(stringInterpolation: self).reversed().prefix { " \t".contains($0) }
        if indent.isEmpty {
            appendInterpolation(string)
        } else {
            let value = string
                .split(separator: "\n", omittingEmptySubsequences: false)
                .joined(separator: "\n" + indent)
            appendLiteral(value)
        }
    }
}
