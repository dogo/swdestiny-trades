//
//  CollectionCardWriter.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

/// Persists a scanned card into the user's collection, resolving-or-creating the collection and
/// **incrementing quantity** when the card (by `code`) is already there — scanning a duplicate adds
/// another copy rather than being rejected.
@MainActor
struct CollectionCardWriter {

    let database: DatabaseProtocol

    func addToCollection(_ card: CardDTO) async throws {
        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)

        let collection: UserCollectionDTO
        if let existing = collections.first {
            collection = existing
        } else {
            collection = UserCollectionDTO()
            _ = try await database.create(UserCollectionDTO.self, value: collection, update: .error)
        }

        let copies = max(card.quantity, 1)
        if let existing = collection.myCollection.first(where: { $0.code == card.code }) {
            existing.quantity += copies
        } else {
            let copy = CardDTO(copying: card)
            copy.id = UUID().uuidString
            copy.quantity = copies
            collection.myCollection.append(copy)
        }

        try await database.save(object: collection, update: .modified)
    }
}
