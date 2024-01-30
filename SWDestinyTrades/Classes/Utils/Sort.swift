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
        return cardsArray.sorted { $0.code < $1.code }
    }

    static func cardsAlphabetically(cardsArray: [CardDTO]) -> [CardDTO] {
        return cardsArray.sorted { $0.name < $1.name }
    }

    static func cardsByColor(cardsArray: [CardDTO]) -> [CardDTO] {
        return sortCards(cardsArray, keyPath: \.factionCode)
    }

    static func cardsByType(cardsArray: [CardDTO]) -> [CardDTO] {
        return sortCards(cardsArray, keyPath: \.typeName.capitalized)
    }

    static func cardsByAffiliation(cardsArray: [CardDTO]) -> [CardDTO] {
        return sortCards(cardsArray, keyPath: \.affiliationCode)
    }

    private static func sortCards(_ cardsArray: [CardDTO], keyPath: KeyPath<CardDTO, some Hashable & Comparable>) -> [CardDTO] {
        let uniqueValues = Set(cardsArray.map { $0[keyPath: keyPath] }).sorted()

        let filteredCards = uniqueValues.flatMap { value in
            cardsArray.filter { $0[keyPath: keyPath] == value }
        }

        return filteredCards
    }
}
