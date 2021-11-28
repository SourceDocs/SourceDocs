//
//  PackageDependency.swift
//  
//
//  Created by Eneko Alonso on 11/28/21.
//

import Foundation

/// `PackageDependency` loads the JSON from `swift package show-dependencies --format json` command
struct PackageDependency: Codable {
    let name: String
    let url: String
    let version: String
    let dependencies: [PackageDependency]
}


/**
 Example JSON

 ```
 {
   "name": "SourceDocs",
   "url": "/Users/enekoalonso/Developer/eneko/SourceDocs",
   "version": "unspecified",
   "path": "/Users/enekoalonso/Developer/eneko/SourceDocs",
   "dependencies": [
     {
       "name": "swift-argument-parser",
       "url": "https://github.com/apple/swift-argument-parser",
       "version": "1.0.2",
       "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/swift-argument-parser",
       "dependencies": [

       ]
     },
     {
       "name": "SourceKitten",
       "url": "https://github.com/jpsim/SourceKitten.git",
       "version": "0.31.1",
       "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/SourceKitten",
       "dependencies": [
         {
           "name": "swift-argument-parser",
           "url": "https://github.com/apple/swift-argument-parser",
           "version": "1.0.2",
           "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/swift-argument-parser",
           "dependencies": [

           ]
         },
         {
           "name": "SWXMLHash",
           "url": "https://github.com/drmohundro/SWXMLHash.git",
           "version": "5.0.1",
           "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/SWXMLHash",
           "dependencies": [

           ]
         },
         {
           "name": "Yams",
           "url": "https://github.com/jpsim/Yams.git",
           "version": "4.0.6",
           "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/Yams",
           "dependencies": [

           ]
         }
       ]
     },
     {
       "name": "MarkdownGenerator",
       "url": "https://github.com/eneko/MarkdownGenerator.git",
       "version": "0.5.0",
       "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/MarkdownGenerator",
       "dependencies": [

       ]
     },
     {
       "name": "Rainbow",
       "url": "https://github.com/onevcat/Rainbow",
       "version": "3.1.5",
       "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/Rainbow",
       "dependencies": [

       ]
     },
     {
       "name": "ProcessRunner",
       "url": "https://github.com/eneko/ProcessRunner.git",
       "version": "1.1.0",
       "path": "/Users/enekoalonso/Developer/eneko/SourceDocs/.build/checkouts/ProcessRunner",
       "dependencies": [

       ]
     }
   ]
 }
 ```
 */
