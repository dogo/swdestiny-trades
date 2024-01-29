//
//  Sort.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 01/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum Sort {

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
        let uniqueColors = Set(cardsArray.map(\.factionCode)).sorted()

        let filteredCards = uniqueColors.flatMap { color in
            cardsArray.filter { $0.factionCode == color }
        }

        return filteredCards
    }

    static func cardsByType(cardsArray: [CardDTO]) -> [CardDTO] {
        let uniqueTypes = Set(cardsArray.map(\.typeName.capitalized)).sorted()

        let filteredCards = uniqueTypes.flatMap { type in
            cardsArray.filter { $0.typeName.capitalized == type }
        }

        return filteredCards
    }

    static func cardsByAffiliation(cardsArray: [CardDTO]) -> [CardDTO] {
        let uniqueAffiliations = Set(cardsArray.map(\.affiliationCode)).sorted()

        let filteredCards = uniqueAffiliations.flatMap { affiliation in
            cardsArray.filter { $0.affiliationCode == affiliation }
        }

        return filteredCards
    }
}
