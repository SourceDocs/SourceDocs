//
//  PackageLoader.swift
//
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation
import Rainbow
import System

final class PackageLoader {

    static func loadPackageDump(from path: String) throws -> PackageDump {
        let result = try system(command: "swift package dump-package",
                                captureOutput: true, currentDirectoryPath: path)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDump.self, from: data)
    }

    static func loadPackageDependencies(from path: String) throws -> PackageDependency {
        try system(command: "swift package resolve", currentDirectoryPath: path)
        let result = try system(command: "swift package show-dependencies --format json",
                                captureOutput: true, currentDirectoryPath: path)
        let data = Data(result.standardOutput.utf8)
        return try JSONDecoder().decode(PackageDependency.self, from: data)
    }

}
