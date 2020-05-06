//
//  PackageLoader.swift
//  
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation
import System

final class PackageLoader {

    static func loadPackageDump() throws -> PackageDump {
        let result = try system(command: "swift package dump-package", captureOutput: true)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDump.self, from: data)
    }

    static func loadPackageDependencies() throws -> PackageDependency {
        let result = try system(command: "swift package show-dependencies --format json", captureOutput: true)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDependency.self, from: data)
    }

}
