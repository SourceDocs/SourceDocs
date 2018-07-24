//
//  Writeable.swift
//  CYaml
//
//  Created by Jim Hildensperger on 18/07/2018.
//

import Foundation
import MarkdownGenerator

protocol Writeable {
    var filePath: String { get }
    var basePath: String { get }

    func write() throws
}

extension MarkdownFile: Writeable {}
