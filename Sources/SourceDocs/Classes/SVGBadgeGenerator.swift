//
//  SVGBadgeGenerator.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 19/07/2018.
//

import Foundation
import AppKit

class SVGBadgeGenerator {
    static func badge(for coverage: Int) -> String {
        let charCount = String(coverage).count
        let length = charCount * 100 + 10
        let offset = charCount * 40 + 975
        let width = charCount * 8 + 104

        return """
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="\(width)" height="20">
            <linearGradient id="b" x2="0" y2="100%">
                <stop offset="0" stop-color="#bbb" stop-opacity=".1" />
                <stop offset="1" stop-opacity=".1" />
            </linearGradient>
            <clipPath id="a">
                <rect width="\(width)" height="20" rx="3" fill="#fff" />
            </clipPath>
            <g clip-path="url(#a)">
                <path fill="#555" d="M0 0h93v20H0z" />
            <path fill="#\(colorForCoverage(coverage: coverage))" d="M93 0h\(length / 10 + 10)v20H93z" />
                <path fill="url(#b)" d="M0 0h\(width)v20H0z" />
            </g>
            <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="110">
                <text x="475" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="830">
                    documentation
                </text>
                <text x="475" y="140" transform="scale(.1)" textLength="830">
                    documentation
                </text>
                <text x="\(offset)" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="\(length)">
                    \(coverage)%
                </text>
                    <text x="\(offset)" y="140" transform="scale(.1)" textLength="\(length)">
                    \(coverage)%
                </text>
            </g>
        </svg>
        """
    }

    private static func colorForCoverage(coverage: Int) -> String {
        switch coverage {
        case ...10: return "e05d44" // red
        case 11...30: return "fe7d37" // orange
        case 31...60: return "dfb317" // yellow
        case 61...85: return "a4a61d" // yellowgreen
        case 86...90: return "97CA00" // green
        default: return "4c1" // brightgreen
        }
    }
}
