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

        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {

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

        return tableViewSource
    }

    static func cardsByColor(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {

        func getColor(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {

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
        return tableViewSource
    }

    static func cardsByType(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {

        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName
        }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in sections {

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

        return tableViewSource
    }

    static func setsByAlphabetically(setList: [SetDTO], sections: [String]) -> [String: [SetDTO]] {

        func getFirstLetter(setDTO: SetDTO) -> String {
            return String(setDTO.name.prefix(1))
        }

        // Build tableSource array
        var tableViewSource = [String: [SetDTO]]()

        for symbol in sections {

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

        return tableViewSource
    }
}
