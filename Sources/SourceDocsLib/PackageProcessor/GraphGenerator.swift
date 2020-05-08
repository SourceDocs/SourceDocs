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
