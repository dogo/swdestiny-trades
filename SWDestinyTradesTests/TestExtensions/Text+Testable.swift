//
//  Text+Testable.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct TextRun: Equatable {
    enum Style: Equatable {
        case plain
        case bold
        case italic
        case icon
    }

    let string: String
    let style: Style
}

extension Text {

    /// Flattens a concatenated `Text` into its non-empty leaf runs by walking SwiftUI's storage with `Mirror`.
    var runs: [TextRun] {
        runs(inheriting: .plain)
    }

    private func runs(inheriting inherited: TextRun.Style) -> [TextRun] {
        let modifiers: [Any] = Mirror(reflecting: self).children.first { $0.label == "modifiers" }
            .map { Mirror(reflecting: $0.value).children.map(\.value) } ?? []
        let style = modifiers.lazy.compactMap(Self.style(of:)).first ?? inherited

        guard let storage = Mirror(reflecting: self).children.first(where: { $0.label == "storage" })?.value,
              let payload = Mirror(reflecting: storage).children.first else { return [] }

        if let verbatim = payload.value as? String {
            return verbatim.isEmpty ? [] : [TextRun(string: verbatim, style: style)]
        }

        let object = payload.value
        if let first: Text = Mirror.extract(variable: "first", from: object),
           let second: Text = Mirror.extract(variable: "second", from: object) {
            return first.runs(inheriting: style) + second.runs(inheriting: style)
        }

        guard let key: LocalizedStringKey = Mirror.extract(variable: "key", from: object) else { return [] }
        let string = Self.resolve(key)
        return string.isEmpty ? [] : [TextRun(string: string, style: style)]
    }

    private static func style(of modifier: Any) -> TextRun.Style? {
        var description = ""
        dump(modifier, to: &description)
        if description.contains("\"swdestiny\"") {
            return .icon
        }
        if description.contains("BoldTextModifier") {
            return .bold
        }
        if description.contains("Text.Modifier.italic") {
            return .italic
        }
        return nil
    }

    private static func resolve(_ key: LocalizedStringKey) -> String {
        var string: String = Mirror.extract(variable: "key", from: key) ?? ""
        let arguments: [Any] = Mirror.extract(variable: "arguments", from: key) ?? []
        for argument in arguments {
            guard let range = string.range(of: "%@") else { break }
            string.replaceSubrange(range, with: formatValue(of: argument))
        }
        return string
    }

    private static func formatValue(of argument: Any) -> String {
        guard let storage = Mirror(reflecting: argument).children.first?.value,
              let value = Mirror(reflecting: storage).children.first?.value,
              let first = Mirror(reflecting: value).children.first?.value else { return "" }
        return String(describing: first)
    }
}
