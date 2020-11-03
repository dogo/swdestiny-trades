//
//  SectionsBuilder.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 02/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum SectionsBuilder {
    // MARK: - CardDTO

    static func alphabetically(cardList: [CardDTO]) -> [String] {
        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        // Build Character Set
        var letters = Set<String>()

        cardList.forEach { _ = letters.insert(getFirstLetter(cardDTO: $0)) }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return sortedSymbols
    }

    static func byColor(cardList: [CardDTO]) -> [String] {
        func getColor(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        // Build color Set
        var colors = Set<String>()

        cardList.forEach { _ = colors.insert(getColor(cardDTO: $0)) }

        return Array(colors)
    }

    static func byType(cardList: [CardDTO]) -> [String] {
        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName
        }

        // Build types Set
        var types = Set<String>()

        cardList.forEach { _ = types.insert(getType(cardDTO: $0)) }

        let sortedSymbols = types.sorted {
            $0 < $1
        }

        return sortedSymbols
    }

    // MARK: - AppearanceProxyHelper.swiftSetDTO

    static func alphabetically(setList: [SetDTO]) -> [String] {
        func getFirstLetter(setDTO: SetDTO) -> String {
            return String(setDTO.name[setDTO.name.startIndex])
        }

        // Build letters Set
        var letters = Set<String>()

        setList.forEach { _ = letters.insert(getFirstLetter(setDTO: $0)) }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return sortedSymbols
    }
}
