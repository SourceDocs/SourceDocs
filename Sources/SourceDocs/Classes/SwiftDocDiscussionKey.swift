//
//  SwiftDocDiscussionKey.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 20/07/2018.
//

import Foundation

enum SwiftDocDiscussionKey: String {
    case attention = "Attention"
    case author = "Author"
    case authors = "Authors"
    case bug = "Bug"
    case complexity = "Complexity"
    case copyright = "Copyright"
    case date = "Date"
    case example = "Example"
    case experiment = "Experiment"
    case important = "Important"
    case invariant = "Invariant"
    case note = "Note"
    case precondition = "Precondition"
    case postcondition = "Postcondition"
    case remark = "Remark"
    case requires = "Requires"
    case seeAlso = "See"
    case since = "Since"
    case version = "Version"
    case warning = "Warning"
    
    case paragraph = "Para"
    case codeListing = "CodeListing"
    case listBullet = "List-Bullet"
    case listNumber = "List-Number"
    case codeLine = "zCodeLineNumbered"
    case item = "Item"
    
    static var calloutKeys: [SwiftDocDiscussionKey] {
        return [ .attention, .author, .authors, .bug, .complexity, .copyright, .date, .example, .experiment, .important, .invariant, .note, .precondition, .postcondition, .remark, .requires, .seeAlso, .since, .version, .warning ]
    }
    
    static var all: [SwiftDocDiscussionKey] {
        return calloutKeys + [ .paragraph, .codeListing, .listBullet, .listNumber, .item ]
    }
    
    static func isCalloutKey(_ string: String?) -> Bool {
        guard SwiftDocDiscussionKey.calloutKeys.contains(where: { (key) -> Bool in return key.rawValue == string }) else {
            return false
        }
        return true
    }
    
    static func isDiscussionKey(_ string: String?) -> Bool {
        guard SwiftDocDiscussionKey.all.contains(where: { (key) -> Bool in return key.rawValue == string }) else {
            return false
        }
        return true
    }
}
