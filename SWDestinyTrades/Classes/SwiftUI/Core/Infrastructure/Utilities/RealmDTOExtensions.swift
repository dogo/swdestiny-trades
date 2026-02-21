//
//  RealmDTOExtensions.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - PersonDTO Extensions

@MainActor
extension PersonDTO: ThreadSafeConvertible {
    typealias ThreadSafeType = PersonThreadSafeData

    func toThreadSafe() -> PersonThreadSafeData {
        return ThreadSafeRealmWrapper.execute {
            PersonThreadSafeData(
                id: self.id,
                name: self.name,
                lastName: self.lastName,
                borrowedCount: self.borrowed.reduce(0) { $0 + $1.quantity },
                lentCount: self.lentMe.reduce(0) { $0 + $1.quantity },
                borrowedItems: Array(self.borrowed),
                lentItems: Array(self.lentMe)
            )
        }
    }

    var threadSafeName: String {
        return ThreadSafeRealmWrapper.execute { self.name }
    }

    var threadSafeLastName: String {
        return ThreadSafeRealmWrapper.execute { self.lastName }
    }

    var threadSafeBorrowedCount: Int {
        return ThreadSafeRealmWrapper.execute {
            Array(self.borrowed).reduce(0) { $0 + $1.quantity }
        }
    }

    var threadSafeLentCount: Int {
        return ThreadSafeRealmWrapper.execute {
            Array(self.lentMe).reduce(0) { $0 + $1.quantity }
        }
    }

    var threadSafeTotalLoanCount: Int {
        return threadSafeBorrowedCount + threadSafeLentCount
    }
}

// MARK: - CardDTO Extensions

@MainActor
extension CardDTO: ThreadSafeConvertible {
    typealias ThreadSafeType = CardThreadSafeData

    func toThreadSafe() -> CardThreadSafeData {
        return ThreadSafeRealmWrapper.execute {
            CardThreadSafeData(
                id: self.id,
                name: self.name,
                cost: self.cost,
                type: self.typeName,
                color: self.factionName,
                setCode: self.setCode,
                rarity: self.rarityName,
                imageUrl: self.imageUrl
            )
        }
    }

    var threadSafeName: String {
        return ThreadSafeRealmWrapper.execute { self.name }
    }

    var threadSafeCost: Int {
        return ThreadSafeRealmWrapper.execute { self.cost }
    }

    var threadSafeType: String {
        return ThreadSafeRealmWrapper.execute { self.typeName }
    }

    var threadSafeColor: String {
        return ThreadSafeRealmWrapper.execute { self.factionName }
    }
}

// MARK: - SetDTO Extensions

@MainActor
extension SetDTO: ThreadSafeConvertible {
    typealias ThreadSafeType = SetThreadSafeData

    func toThreadSafe() -> SetThreadSafeData {
        return ThreadSafeRealmWrapper.execute {
            SetThreadSafeData(
                id: self.id,
                name: self.name,
                code: self.code,
                releaseDate: "",
                cardCount: 0
            )
        }
    }

    var threadSafeName: String {
        return ThreadSafeRealmWrapper.execute { self.name }
    }

    var threadSafeCode: String {
        return ThreadSafeRealmWrapper.execute { self.code }
    }

    var threadSafeCardCount: Int {
        return ThreadSafeRealmWrapper.execute { 0 }
    }
}

// MARK: - DeckDTO Extensions

@MainActor
extension DeckDTO: ThreadSafeConvertible {
    typealias ThreadSafeType = DeckThreadSafeData

    func toThreadSafe() -> DeckThreadSafeData {
        return ThreadSafeRealmWrapper.execute {
            DeckThreadSafeData(
                id: self.id,
                name: self.name,
                format: "",
                cardCount: self.list.reduce(0) { $0 + $1.quantity },
                cards: Array(self.list)
            )
        }
    }

    var threadSafeName: String {
        return ThreadSafeRealmWrapper.execute { self.name }
    }

    var threadSafeFormat: String {
        return ThreadSafeRealmWrapper.execute { "" }
    }

    var threadSafeCardCount: Int {
        return ThreadSafeRealmWrapper.execute {
            Array(self.list).reduce(0) { $0 + $1.quantity }
        }
    }
}

// MARK: - UserCollectionDTO Extensions

@MainActor
extension UserCollectionDTO: ThreadSafeConvertible {
    typealias ThreadSafeType = UserCollectionThreadSafeData

    func toThreadSafe() -> UserCollectionThreadSafeData {
        return ThreadSafeRealmWrapper.execute {
            UserCollectionThreadSafeData(
                id: self.id,
                cards: Array(self.myCollection)
            )
        }
    }

    var threadSafeCardCount: Int {
        return ThreadSafeRealmWrapper.execute { self.myCollection.count }
    }
}

// MARK: - Thread Safe Data Structures

struct PersonThreadSafeData: Sendable {
    let id: String
    let name: String
    let lastName: String
    let borrowedCount: Int
    let lentCount: Int
    let borrowedItems: [CardDTO]
    let lentItems: [CardDTO]

    var totalLoanCount: Int {
        return borrowedCount + lentCount
    }

    var hasLoans: Bool {
        return totalLoanCount > 0
    }
}

struct CardThreadSafeData: Sendable {
    let id: String
    let name: String
    let cost: Int
    let type: String
    let color: String
    let setCode: String
    let rarity: String
    let imageUrl: String
}

struct SetThreadSafeData: Sendable {
    let id: String
    let name: String
    let code: String
    let releaseDate: String
    let cardCount: Int
}

struct DeckThreadSafeData: Sendable {
    let id: String
    let name: String
    let format: String
    let cardCount: Int
    let cards: [CardDTO]
}

struct UserCollectionThreadSafeData: Sendable {
    let id: String
    let cards: [CardDTO]
}
