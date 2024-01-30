//
//  Split.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum Split {
    static func cardsAlphabetically(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        // Helper function to get the first letter of a card
        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {
            let cardsDTO = cardList.filter { getFirstLetter(cardDTO: $0) == symbol }
                .sorted { $0.name < $1.name }

            tableViewSource[symbol] = cardsDTO
        }

        return tableViewSource
    }

    static func cardsByColor(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        // Helper function to get the color of a card
        func getColor(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {
            let cardsDTO = cardList.filter { getColor(cardDTO: $0) == symbol }
                .sorted { $0.name < $1.name }

            tableViewSource[symbol] = cardsDTO
        }

        return tableViewSource
    }

    static func cardsByType(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        // Helper function to get the type of a card
        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName
        }

        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {
            let cardsDTO = cardList.filter { getType(cardDTO: $0) == symbol }
                .sorted { $0.name < $1.name }

            tableViewSource[symbol] = cardsDTO
        }

        return tableViewSource
    }

    static func setsByAlphabetically(setList: [SetDTO], sections: [String]) -> [String: [SetDTO]] {
        // Helper function to get the first letter of a set
        func getFirstLetter(setDTO: SetDTO) -> String {
            return String(setDTO.name.prefix(1))
        }

        var tableViewSource = [String: [SetDTO]]()

        for symbol in sections {
            let setsDTO = setList.filter { getFirstLetter(setDTO: $0) == symbol }
                .sorted { $0.name < $1.name }

            tableViewSource[symbol] = setsDTO
        }

        return tableViewSource
    }
}
