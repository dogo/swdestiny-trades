//
//  SwiftDataManager+Mapping.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import SwiftData

// MARK: - Populate SD from DTO

extension SwiftDataManager {

    func populate(card: CardSD, from dto: CardDTO) {
        populateCardIdentity(card: card, from: dto)
        populateCardClassification(card: card, from: dto)
        populateCardStats(card: card, from: dto)
        populateCardPresentation(card: card, from: dto)
    }

    private func populateCardIdentity(card: CardSD, from dto: CardDTO) {
        card.code = dto.code
        card.name = dto.name
        card.subtitle = dto.subtitle
    }

    private func populateCardClassification(card: CardSD, from dto: CardDTO) {
        card.setCode = dto.setCode
        card.setName = dto.setName
        card.typeCode = dto.typeCode
        card.typeName = dto.typeName
        card.factionCode = dto.factionCode
        card.factionName = dto.factionName
        card.affiliationCode = dto.affiliationCode
        card.affiliationName = dto.affiliationName
        card.rarityCode = dto.rarityCode
        card.rarityName = dto.rarityName
    }

    private func populateCardStats(card: CardSD, from dto: CardDTO) {
        card.position = dto.position
        card.ttscardid = dto.ttscardid
        card.cost = dto.cost
        card.health = dto.health
        card.points = dto.points
        card.deckLimit = dto.deckLimit
        card.isUnique = dto.isUnique
        card.hasDie = dto.hasDie
        card.label = dto.label
        card.cp = dto.cp
        card.quantity = dto.quantity
        card.isElite = dto.isElite
        card.dieFaces = dto.dieFaces
    }

    private func populateCardPresentation(card: CardSD, from dto: CardDTO) {
        card.text = dto.text
        card.flavor = dto.flavor
        card.illustrator = dto.illustrator
        card.externalUrl = dto.externalUrl
        card.imageUrl = dto.imageUrl
    }

    func populate(set: SetSD, from dto: SetDTO) {
        set.id = dto.id
        set.name = dto.name
    }

    func populate(deck: DeckSD, from dto: DeckDTO) {
        deck.name = dto.name
        deck.list = dto.list.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }

    func populate(person: PersonSD, from dto: PersonDTO) {
        person.name = dto.name
        person.lastName = dto.lastName
        person.lentMe = dto.lentMe.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
        person.borrowed = dto.borrowed.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }

    func populate(collection: UserCollectionSD, from dto: UserCollectionDTO) {
        collection.myCollection = dto.myCollection.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }
}

// MARK: - Map SD → DTO

extension SwiftDataManager {

    func cardDTO(from stored: CardSD) -> CardDTO {
        let dto = CardDTO()
        dto.id = stored.id
        dto.code = stored.code
        dto.name = stored.name
        dto.subtitle = stored.subtitle
        dto.setCode = stored.setCode
        dto.setName = stored.setName
        dto.typeCode = stored.typeCode
        dto.typeName = stored.typeName
        dto.factionCode = stored.factionCode
        dto.factionName = stored.factionName
        dto.affiliationCode = stored.affiliationCode
        dto.affiliationName = stored.affiliationName
        dto.rarityCode = stored.rarityCode
        dto.rarityName = stored.rarityName
        dto.position = stored.position
        dto.ttscardid = stored.ttscardid
        dto.cost = stored.cost
        dto.health = stored.health
        dto.points = stored.points
        dto.text = stored.text
        dto.deckLimit = stored.deckLimit
        dto.flavor = stored.flavor
        dto.illustrator = stored.illustrator
        dto.isUnique = stored.isUnique
        dto.hasDie = stored.hasDie
        dto.externalUrl = stored.externalUrl
        dto.imageUrl = stored.imageUrl
        dto.label = stored.label
        dto.cp = stored.cp
        dto.quantity = stored.quantity
        dto.isElite = stored.isElite
        dto.dieFaces = stored.dieFaces
        return dto
    }

    func setDTO(from stored: SetSD) -> SetDTO {
        let dto = SetDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.code = stored.code
        return dto
    }

    func deckDTO(from stored: DeckSD) -> DeckDTO {
        let dto = DeckDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.list = stored.list.map { cardDTO(from: $0) }
        return dto
    }

    func personDTO(from stored: PersonSD) -> PersonDTO {
        let dto = PersonDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.lastName = stored.lastName
        dto.lentMe = stored.lentMe.map { cardDTO(from: $0) }
        dto.borrowed = stored.borrowed.map { cardDTO(from: $0) }
        return dto
    }

    func userCollectionDTO(from stored: UserCollectionSD) -> UserCollectionDTO {
        let dto = UserCollectionDTO()
        dto.id = stored.id
        dto.myCollection = stored.myCollection.map { cardDTO(from: $0) }
        return dto
    }
}
