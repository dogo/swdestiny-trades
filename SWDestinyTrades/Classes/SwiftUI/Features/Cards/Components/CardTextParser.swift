//
//  CardTextParser.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

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

private enum CardTextSegment {
    case plain(String)
    case marker(String)
    case bold(String)
    case italic(String)
}

private func parseCardTextSegments(_ source: String) -> [CardTextSegment] {
    var segments: [CardTextSegment] = []
    var index = source.startIndex

    while index < source.endIndex {
        if source[index] == "[",
           let close = source[index...].firstIndex(of: "]") {
            let markerStart = source.index(after: index)
            let markerText = String(source[markerStart..<close]).lowercased()
            if !markerText.isEmpty, markerText.allSatisfy(\.isLetter) {
                segments.append(.marker(markerText))
                index = source.index(after: close)
                continue
            }
        }

        if let (openTag, closeTag, style) = matchingTag(at: index, in: source),
           let closeRange = source.range(of: closeTag, range: openTag.upperBound..<source.endIndex) {
            let content = String(source[openTag.upperBound..<closeRange.lowerBound])
            segments.append(style(content))
            index = closeRange.upperBound
            continue
        }

        let nextSpecial = nextSpecialIndex(from: index, in: source) ?? source.endIndex
        if nextSpecial == index {
            segments.append(.plain(String(source[index])))
            index = source.index(after: index)
        } else {
            let plain = String(source[index..<nextSpecial])
            if !plain.isEmpty {
                segments.append(.plain(plain))
            }
            index = nextSpecial
        }
    }

    return segments
}

private func matchingTag(
    at index: String.Index,
    in source: String
) -> (open: Range<String.Index>, close: String, style: (String) -> CardTextSegment)? {
    let tags: [(String, String, (String) -> CardTextSegment)] = [
        ("<b>", "</b>", CardTextSegment.bold),
        ("<i>", "</i>", CardTextSegment.italic),
        ("<em>", "</em>", CardTextSegment.italic),
        ("<cite>", "</cite>", CardTextSegment.italic)
    ]

    for (open, close, style) in tags {
        if let range = source.range(of: open, range: index..<source.endIndex), range.lowerBound == index {
            return (range, close, style)
        }
    }

    return nil
}

private func nextSpecialIndex(from index: String.Index, in source: String) -> String.Index? {
    let bracketIndex = source[index...].firstIndex(of: "[")
    let tagIndex = source[index...].firstIndex(of: "<")

    switch (bracketIndex, tagIndex) {
    case let (lhs?, rhs?):
        return min(lhs, rhs)
    case let (lhs?, nil):
        return lhs
    case let (nil, rhs?):
        return rhs
    case (nil, nil):
        return nil
    }
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
        let segments = parseCardTextSegments(self)
        for segment in segments {
            switch segment {
            case let .plain(text):
                result += Text(text)
            case let .marker(marker):
                if let icon = icon(forMarker: marker) {
                    result += Text.swdIcon(icon, size: iconSize)
                } else {
                    result += Text("[\(marker)]")
                }
            case let .bold(text):
                result += Text(text).bold()
            case let .italic(text):
                result += Text(text).italic()
            }
        }
        return result
    }
}
