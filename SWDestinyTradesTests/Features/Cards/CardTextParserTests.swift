//
//  CardTextParserTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import Testing

@testable import SWDestinyTrades

@MainActor
final class CardTextParserTests {

    @Test
    func plainText_isASingleRun() {
        #expect("Deal 2 damage.".toCardText().runs == [TextRun(string: "Deal 2 damage.", style: .plain)])
    }

    @Test
    func emptyText_hasNoRuns() {
        #expect("".toCardText().runs.isEmpty)
    }

    @Test
    func dieSymbolMarker_becomesIcon() {
        #expect("Turn a die to [melee].".toCardText().runs == [
            TextRun(string: "Turn a die to ", style: .plain),
            TextRun(string: SWDIcon.icMelee.unicode, style: .icon),
            TextRun(string: ".", style: .plain)
        ])
    }

    @Test
    func marker_isCaseInsensitive() {
        #expect("[RESOURCE]".toCardText().runs == [TextRun(string: SWDIcon.icResource.unicode, style: .icon)])
    }

    @Test
    func setCodeMarker_becomesSetIcon() {
        #expect("[aw]".toCardText().runs == [TextRun(string: SWDIcon.icAwakenings.unicode, style: .icon)])
    }

    @Test
    func unknownMarker_isKeptAsText() {
        #expect("[foo]".toCardText().runs == [TextRun(string: "[foo]", style: .plain)])
    }

    @Test
    func bracketWithNonLetters_isKeptAsText() {
        #expect("[1] and [ ]".toCardText().runs.map(\.string).joined() == "[1] and [ ]")
        #expect("[1] and [ ]".toCardText().runs.allSatisfy { $0.style == .plain })
    }

    @Test
    func unclosedBracket_isKeptAsText() {
        #expect("Cost [3".toCardText().runs.map(\.string).joined() == "Cost [3")
    }

    @Test
    func boldTag_rendersBold() {
        #expect("<b>Action</b> - Roll.".toCardText().runs == [
            TextRun(string: "Action", style: .bold),
            TextRun(string: " - Roll.", style: .plain)
        ])
    }

    @Test(arguments: ["i", "em", "cite"])
    func italicTags_renderItalic(tag: String) {
        #expect("<\(tag)>Rebel</\(tag)>".toCardText().runs == [TextRun(string: "Rebel", style: .italic)])
    }

    @Test
    func unclosedTag_isKeptAsText() {
        #expect("<b>Action".toCardText().runs.map(\.string).joined() == "<b>Action")
        #expect("<b>Action".toCardText().runs.allSatisfy { $0.style == .plain })
    }

    @Test
    func unknownTag_isKeptAsText() {
        #expect("<u>x</u>".toCardText().runs.map(\.string).joined() == "<u>x</u>")
    }

    @Test
    func mixedContent_keepsOrder() {
        #expect("<b>Power</b> [focus] <i>once</i>".toCardText().runs == [
            TextRun(string: "Power", style: .bold),
            TextRun(string: " ", style: .plain),
            TextRun(string: SWDIcon.icFocus.unicode, style: .icon),
            TextRun(string: " ", style: .plain),
            TextRun(string: "once", style: .italic)
        ])
    }
}
