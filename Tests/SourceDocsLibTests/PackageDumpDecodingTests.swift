//
//  PackageDumpDecodingTests.swift
//  
//
//  Created by Eneko Alonso on 11/28/21.
//

import XCTest
@testable import SourceDocsLib

final class PackageDumpDecodingTests: XCTestCase {

    func testDecodeJSON() throws {
        let dump = try JSONDecoder().decode(PackageDump.self, from: Data(examplePackageDump.utf8))

        XCTAssertEqual(dump.name, "SourceDocs")
        XCTAssertEqual(dump.dependencies.first?.requirementDescription, "1.0.0..<2.0.0")
    }
}

let examplePackageDump = """
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
 """
