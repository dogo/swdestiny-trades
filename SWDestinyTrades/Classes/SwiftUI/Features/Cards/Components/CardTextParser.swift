//
//  CardTextParser.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

private extension Text {
    static func += (lhs: inout Text, rhs: Text) {
        lhs = lhs + rhs
    }
}

private let dieSymbolIcons: [String: SWDIcon] = [
    "ranged": .icRanged,
    "resource": .icResource,
    "melee": .icMelee,
    "indirect": .icIndirect,
    "special": .icSpecial,
    "blank": .icBlank,
    "disrupt": .icDisrupt,
    "focus": .icFocus,
    "discard": .icDiscard,
    "shield": .icShield
]

private func icon(forMarker marker: String) -> SWDIcon? {
    dieSymbolIcons[marker] ?? SetDTO.iconsByCode[marker]
}

extension String {
    /// Parses card text and returns a `Text` view where:
    /// - `[marker]` tokens are replaced with the corresponding SWDestiny icon glyph.
    ///   Die symbols.
    ///   Set codes.
    /// - `<b>…</b>` segments are rendered bold.
    /// - `<i>…</i>` and `<em>…</em>` segments are rendered italic.
    /// - `<cite>…</cite>` segments are rendered italic (flavor text attribution).
    func toCardText(iconSize: CGFloat = 17) -> Text {
        var result = Text("")
        var lastEnd = startIndex
        let pattern = /\[([a-zA-Z]+)\]|<b>(.*?)<\/b>|<i>(.*?)<\/i>|<em>(.*?)<\/em>|<cite>(.*?)<\/cite>/

        for match in matches(of: pattern) {
            let textBefore = String(self[lastEnd ..< match.range.lowerBound])
            if !textBefore.isEmpty {
                result += Text(textBefore)
            }

            if let markerSubstring = match.output.1 {
                let marker = String(markerSubstring).lowercased()
                if let icon = icon(forMarker: marker) {
                    result += Text.swdIcon(icon, size: iconSize)
                } else {
                    result += Text("[\(marker)]")
                }
            } else if let boldContent = match.output.2 {
                result += Text(String(boldContent)).bold()
            } else if let italicContent = match.output.3 {
                result += Text(String(italicContent)).italic()
            } else if let emContent = match.output.4 {
                result += Text(String(emContent)).italic()
            } else if let citeContent = match.output.5 {
                result += Text(String(citeContent)).italic()
            }

            lastEnd = match.range.upperBound
        }

        let remaining = String(self[lastEnd...])
        if !remaining.isEmpty {
            result += Text(remaining)
        }

        return result
    }
}
