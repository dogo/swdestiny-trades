//
//  SectionsBuilder.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 02/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum SectionsBuilder {

    // MARK: - Alphabetically

    static func alphabetically(cardList: [CardDTO]) -> [String] {
        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name.prefix(1))
        }

        let letters = Set(cardList.map { getFirstLetter(cardDTO: $0) })

        return Array(letters).sorted()
    }

    static func alphabetically(setList: [SetDTO]) -> [String] {
        func getFirstLetter(setDTO: SetDTO) -> String {
            return String(setDTO.name.prefix(1))
        }

        let letters = Set(setList.map { getFirstLetter(setDTO: $0) })

        return Array(letters).sorted()
    }

    // MARK: - byColor

    static func byColor(cardList: [CardDTO]) -> [String] {
        func getColor(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        let colors = Set(cardList.map { getColor(cardDTO: $0) })
        
        return Array(colors).sorted()
    }

    // MARK: - byType

    static func byType(cardList: [CardDTO]) -> [String] {
        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName
        }

        let types = Set(cardList.map { getType(cardDTO: $0) })

        return Array(types).sorted()
    }
}
