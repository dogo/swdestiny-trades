//
//  Sort.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 01/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

final class Sort {

    static func cardsByNumber(cardsArray: [CardDTO]) -> [CardDTO] {
        let source = cardsArray.sorted {
            $0.code < $1.code
        }
        return source
    }

    static func cardsAlphabetically(cardsArray: [CardDTO]) -> [CardDTO] {
        let source = cardsArray.sorted {
            $0.name < $1.name
        }
        return source
    }

    static func cardsByColor(cardsArray: [CardDTO]) -> [CardDTO] {
        var colors = Set<String>()
        var source = [CardDTO]()

        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        cardsArray.forEach {_ = colors.insert(getType(cardDTO: $0)) }

        for symbol in colors {
            for card in cardsArray {
                if symbol == card.factionCode {
                    source.append(card)
                }
            }
        }
        return Sort.cardsAlphabetically(cardsArray: source)
    }

    static func cardsByType(cardsArray: [CardDTO]) -> [CardDTO] {
        var types = Set<String>()
        var source = [CardDTO]()

        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.typeName.capitalized
        }

        cardsArray.forEach {_ = types.insert(getType(cardDTO: $0)) }

        for symbol in types {
            for card in cardsArray {
                if symbol == getType(cardDTO: card) {
                    source.append(card)
                }
            }
        }
        return Sort.cardsAlphabetically(cardsArray: source)
    }
}
