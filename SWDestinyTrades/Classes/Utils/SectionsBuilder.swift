//
//  SectionsBuilder.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 02/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum SectionsBuilder {

    // MARK: - Generic Sorting

    private static func uniqueValues<T>(for items: [T], extractValue: (T) -> String) -> [String] {
        let values = Set(items.map { extractValue($0) })
        return Array(values).sorted()
    }

    // MARK: - Alphabetically

    static func alphabetically(cardList: [CardDTO]) -> [String] {
        return uniqueValues(for: cardList) { String($0.name.prefix(1)) }
    }

    static func alphabetically(setList: [SetDTO]) -> [String] {
        return uniqueValues(for: setList) { String($0.name.prefix(1)) }
    }

    // MARK: - byColor

    static func byColor(cardList: [CardDTO]) -> [String] {
        return uniqueValues(for: cardList) { $0.factionCode }
    }

    // MARK: - byType

    static func byType(cardList: [CardDTO]) -> [String] {
        return uniqueValues(for: cardList) { $0.typeName }
    }
}
