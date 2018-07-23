//
//  CoverageBadge.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 19/07/2018.
//

import Foundation
import AppKit

struct CoverageBadge: Writeable {
    let coverage: Int
    let basePath: String

    var filePath: String {
        return basePath + "/" + SourceDocs.defaultCoverageSvgFilename
    }

    private var colorForCoverage: String {
        switch coverage {
        case ...10: return "e05d44" // red
        case 11...30: return "fe7d37" // orange
        case 31...60: return "dfb317" // yellow
        case 61...85: return "a4a61d" // yellowgreen
        case 86...90: return "97CA00" // green
        default: return "4c1" // brightgreen
        }
    }

    private var svg: String {
        let padding: (h: CGFloat, v: CGFloat) = (6, 4)
        let fontSize: CGFloat = 11
        let fontName = "Verdana"
        let descriptionString = "documentation"
        let coverageString = "\(coverage)%"

        let font = NSFont(name: fontName, size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)
        let fontAttributes = [NSAttributedStringKey.font: font]

        let descriptionSize = (descriptionString as NSString).size(withAttributes: fontAttributes)
        let coverageSize = (coverageString as NSString).size(withAttributes: fontAttributes)

        let width = descriptionSize.width + coverageSize.width + padding.h * 4
        let height = descriptionSize.height + padding.v
        let offset = descriptionSize.width + padding.h * 2
        let y = height/2.0 + padding.v
        let x = offset + padding.h

        return """
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="\(width)" height="\(height)">
            <linearGradient id="b" x2="0" y2="100%">
                <stop offset="0" stop-color="#bbb" stop-opacity=".1" />
                <stop offset="1" stop-opacity=".1" />
            </linearGradient>
            <clipPath id="a">
                <rect width="\(width)" height="\(height)" rx="4" ry="4" fill="#fff" />
            </clipPath>
            <g clip-path="url(#a)" >
                <path fill="#555" d="M0 0h\(offset)v\(height)H0z" />
                <path fill="#\(colorForCoverage)" d="M\(offset) 0h\(coverageSize.width + 2 * padding.h)v\(height)H\(offset)z" />
                <path fill="url(#b)" d="M0 0h\(width)v\(height)H0z" />
            </g>
            <g fill="#fff" text-anchor="left" font-family="\(fontName),Geneva,sans-serif" font-size="\(fontSize)">
                <text x="\(padding.h)" y="\(y)" fill="#010101" fill-opacity=".3" textLength="\(descriptionSize.width)">
                    \(descriptionString)
                </text>
                <text x="\(padding.h)" y="\(y)" textLength="\(descriptionSize.width)">
                    \(descriptionString)
                </text>
                <text x="\(x)" y="\(y)" fill="#010101" fill-opacity=".3" textLength="\(coverageSize.width)">
                    \(coverageString)
                </text>
                <text x="\(x)" y="\(y)" textLength="\(coverageSize.width)">
                    \(coverageString)
                </text>
            </g>
        </svg>
        """
    }

    func write() throws {
        try svg.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
