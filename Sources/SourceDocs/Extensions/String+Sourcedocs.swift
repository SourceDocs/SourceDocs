//
//  String+Sourcedocs.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 20/07/2018.
//

import Foundation

extension String {
    mutating func replacingMatches(_ regex: NSRegularExpression, with template: String = "") {
        let range = NSMakeRange(0, self.count)
        self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
    }
}
