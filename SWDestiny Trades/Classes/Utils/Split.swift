//
//  Split.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

final class Split {

    static func cardsAlphabetically(cardList: [CardDTO]) -> (firstLetters: [String], source: [String : [CardDTO]]) {

        // Build Character Set
        var letters = Set<String>()

        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        cardList.forEach {_ = letters.insert(getFirstLetter(cardDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in letters {

            var cardsDTO = [CardDTO]()

            for card in cardList {
                if symbol == getFirstLetter(cardDTO: card) {
                    cardsDTO.append(card)
                }
            }
            tableViewSource[symbol] = cardsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    static func cardsByColor(cardList: [CardDTO]) -> (sections: [String], source: [String : [CardDTO]]) {

        // Build color Set
        var colors = Set<String>()

        func getColor(cardDTO: CardDTO) -> String {
            return NSLocalizedString(cardDTO.factionCode.uppercased(), comment: "").capitalized
        }

        cardList.forEach {_ = colors.insert(getColor(cardDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in colors {

            var cardsDTO = [CardDTO]()

            for card in cardList {
                if symbol == getColor(cardDTO: card) {
                    cardsDTO.append(card)
                }
            }
            tableViewSource[symbol] = cardsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = colors.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    static func cardsByType(cardList: [CardDTO]) -> (sections: [String], source: [String : [CardDTO]]) {

        // Build types Set
        var types = Set<String>()

        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName.capitalized
        }

        cardList.forEach {_ = types.insert(getType(cardDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in types {

            var cardsDTO = [CardDTO]()

            for card in cardList {
                if symbol == getType(cardDTO: card) {
                    cardsDTO.append(card)
                }
            }
            tableViewSource[symbol] = cardsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = types.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    static func setsByAlphabetically(setList: [SetDTO]) -> (firstLetters: [String], source: [String : [SetDTO]]) {

        // Build Character Set
        var letters = Set<String>()

        func getFirstLetter(setDTO: SetDTO) -> String {
            return String(setDTO.name.characters.prefix(1))
        }

        setList.forEach {_ = letters.insert(getFirstLetter(setDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [String: [SetDTO]]()

        for symbol in letters {

            var setsDTO = [SetDTO]()

            for set in setList {
                if symbol == getFirstLetter(setDTO: set) {
                    setsDTO.append(set)
                }
            }
            tableViewSource[symbol] = setsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }
}
