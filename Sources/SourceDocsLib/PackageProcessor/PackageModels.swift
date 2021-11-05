//
//  PackageModels.swift
//
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation
import PackageModel

// MARK: - Package Dump (swift package dump-package)

struct PackageDump: Codable {
    let name: String
    let platforms: [SimplePlatform]
    let products: [ProductDescription]
    let targets: [TargetDescription]
    let dependencies: [PackageModel.PackageDependency]
    let manifestVersion: String?
    let swiftLanguageVersions: [SwiftLanguageVersion]?
}

struct SimplePlatform: Codable {
    let platformName: String
    let version: String?
}

extension PackageModel.PackageDependency {
    var requirementDescription: String {
        switch self {
        case .fileSystem:
            return ""
        case .sourceControl(let settings):
            return settings.requirement.description
        case .registry(let settings):
            return settings.requirement.description
        }
    }
}

extension PackageDependency: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .fileSystem(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .fileSystem)
            try unkeyedContainer.encode(settings)
        case .sourceControl(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .sourceControl)
            try unkeyedContainer.encode(settings)
        case .registry(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .registry)
            try unkeyedContainer.encode(settings)
        }
    }
}

extension TargetDescription.Dependency {
    var label: String {
        switch self {
        case let .byName(name, _):
            return name
        case let .product(name, _, _):
            return name
        case let .target(name, _):
            return name
        }
    }
}

// MARK: - Package Dependencies (swift package show-dependencies --format json)

struct PackageDependency: Codable {
    let name: String
    let url: String
    let version: String
    let dependencies: [PackageDependency]
}

// MARK: Helper extensions for PackageModel

extension ProductType {
    var label: String {
        switch description {
        case "automatic":
            return "Library (automatic)"
        case "dynamic":
            return "Library (dynamic)"
        case "static":
            return "Library (static)"
        default:
            return description.capitalized
        }
    }
}

extension PackageDependency {
    var label: String {
        let label = URL(string: url)?.lastPathComponent.replacingOccurrences(of: ".git", with: "")
        return label ?? url
    }
}
