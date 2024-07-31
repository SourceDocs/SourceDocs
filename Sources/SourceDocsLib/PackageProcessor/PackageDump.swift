//
//  PackageDump.swift
//
//
//  Created by Eneko Alonso on 5/5/20.
//

import Foundation

/// Package Dump loads the JSON from `swift package dump-package` command
struct PackageDump: Codable {
    let dependencies: [PackageDependency]
    let name: String
    let platforms: [SimplePlatform]
    let products: [ProductDescription]
    let targets: [TargetDescription]

    struct PackageDependency: Codable {
        let scm: [SourceControlManager]?

        struct SourceControlManager: Codable {
            let identity: String
            let location: String
            let requirement: Requirement

            struct Requirement: Codable {
                let range: [VersionRange]?

                struct VersionRange: Codable {
                    let lowerBound: String
                    let upperBound: String
                }
            }
        }

        var label: String {
            return scm?.first?.identity ?? "[]"
        }

        var url: String {
            return scm?.first?.location ?? ""
        }

        var requirementDescription: String {
            if let range = scm?.first?.requirement.range?.first {
                return "\(range.lowerBound)..<\(range.upperBound)"
            }
            return ""
        }
    }

    struct SimplePlatform: Codable {
        let platformName: String
        let version: String?
    }

    struct ProductDescription: Codable {
        let name: String
        let targets: [String]
        let type: ProductType

        struct ProductType: Codable {
            let executable: String?
            let library: [String]?

            var label: String {
                if let _ = library?.first {
                    return "library"
                }
                return "executable"
            }
        }
    }

    struct TargetDescription: Codable {
        let dependencies: [Dependency]
        let name: String
        let type: TargetType

        struct Dependency: Codable {
            let product: [String?]?
            let byName: [String?]?

            var label: String {
                if let dependencies = product {
                    return dependencies.compactMap { $0 }.joined(separator: ", ")
                }
                if let dependencies = byName {
                    return dependencies.compactMap { $0 }.joined(separator: ", ")
                }
                return ""
            }
        }

        enum TargetType: String, Codable {
            case regular
            case test
            case executable
        }
    }
}

/**
 Example JSON

 ```
 {
   "cLanguageStandard" : null,
   "cxxLanguageStandard" : null,
   "dependencies" : [
     {
       "scm" : [
         {
           "identity" : "swift-argument-parser",
           "location" : "https://github.com/apple/swift-argument-parser",
           "productFilter" : null,
           "requirement" : {
             "range" : [
               {
                 "lowerBound" : "1.0.0",
                 "upperBound" : "2.0.0"
               }
             ]
           }
         }
       ]
     },
     {
       "scm" : [
         {
           "identity" : "sourcekitten",
           "location" : "https://github.com/jpsim/SourceKitten.git",
           "productFilter" : null,
           "requirement" : {
             "range" : [
               {
                 "lowerBound" : "0.29.0",
                 "upperBound" : "1.0.0"
               }
             ]
           }
         }
       ]
     },
     {
       "scm" : [
         {
           "identity" : "markdowngenerator",
           "location" : "https://github.com/eneko/MarkdownGenerator.git",
           "productFilter" : null,
           "requirement" : {
             "range" : [
               {
                 "lowerBound" : "0.4.0",
                 "upperBound" : "1.0.0"
               }
             ]
           }
         }
       ]
     },
     {
       "scm" : [
         {
           "identity" : "rainbow",
           "location" : "https://github.com/onevcat/Rainbow",
           "productFilter" : null,
           "requirement" : {
             "range" : [
               {
                 "lowerBound" : "3.0.0",
                 "upperBound" : "4.0.0"
               }
             ]
           }
         }
       ]
     },
     {
       "scm" : [
         {
           "identity" : "processrunner",
           "location" : "https://github.com/eneko/ProcessRunner.git",
           "productFilter" : null,
           "requirement" : {
             "range" : [
               {
                 "lowerBound" : "1.1.0",
                 "upperBound" : "2.0.0"
               }
             ]
           }
         }
       ]
     }
   ],
   "name" : "SourceDocs",
   "packageKind" : "root",
   "pkgConfig" : null,
   "platforms" : [
     {
       "options" : [

       ],
       "platformName" : "macos",
       "version" : "10.15"
     }
   ],
   "products" : [
     {
       "name" : "sourcedocs",
       "settings" : [

       ],
       "targets" : [
         "SourceDocsCLI"
       ],
       "type" : {
         "executable" : null
       }
     },
     {
       "name" : "SourceDocsLib",
       "settings" : [

       ],
       "targets" : [
         "SourceDocsLib"
       ],
       "type" : {
         "library" : [
           "automatic"
         ]
       }
     }
   ],
   "providers" : null,
   "swiftLanguageVersions" : null,
   "targets" : [
     {
       "dependencies" : [
         {
           "product" : [
             "ArgumentParser",
             "swift-argument-parser",
             null
           ]
         },
         {
           "byName" : [
             "SourceDocsLib",
             null
           ]
         },
         {
           "byName" : [
             "Rainbow",
             null
           ]
         }
       ],
       "exclude" : [

       ],
       "name" : "SourceDocsCLI",
       "resources" : [

       ],
       "settings" : [

       ],
       "type" : "regular"
     },
     {
       "dependencies" : [
         {
           "product" : [
             "SourceKittenFramework",
             "SourceKitten",
             null
           ]
         },
         {
           "byName" : [
             "MarkdownGenerator",
             null
           ]
         },
         {
           "byName" : [
             "Rainbow",
             null
           ]
         },
         {
           "byName" : [
             "ProcessRunner",
             null
           ]
         }
       ],
       "exclude" : [

       ],
       "name" : "SourceDocsLib",
       "resources" : [

       ],
       "settings" : [

       ],
       "type" : "regular"
     },
     {
       "dependencies" : [

       ],
       "exclude" : [

       ],
       "name" : "SourceDocsDemo",
       "resources" : [

       ],
       "settings" : [

       ],
       "type" : "regular"
     },
     {
       "dependencies" : [
         {
           "byName" : [
             "ProcessRunner",
             null
           ]
         }
       ],
       "exclude" : [

       ],
       "name" : "SourceDocsCLITests",
       "resources" : [

       ],
       "settings" : [

       ],
       "type" : "test"
     },
     {
       "dependencies" : [
         {
           "byName" : [
             "SourceDocsLib",
             null
           ]
         }
       ],
       "exclude" : [

       ],
       "name" : "SourceDocsLibTests",
       "resources" : [

       ],
       "settings" : [

       ],
       "type" : "test"
     }
   ],
   "toolsVersion" : {
     "_version" : "5.1.0"
   }
 }
 ```
 */
