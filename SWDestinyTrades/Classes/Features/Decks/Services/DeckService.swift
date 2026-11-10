//
//  DeckService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class DeckService: DeckServiceProtocol {

    private let client: HttpClientProtocol
    private var pendingSave: Task<Void, Error>?

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func retrieveDecks() async throws -> [DeckDTO] {
        let endpoint = DecksEndpoint()

        return try await client.request(endpoint, decode: [RemoteDeckDTO].self).map(\.deck)
    }

    func saveDeck(_ deck: DeckDTO, remoteID: Int) async throws {
        let previousSave = pendingSave
        let save = Task { [client] in
            _ = await previousSave?.result
            let endpoint = try SaveDeckEndpoint(remoteID: remoteID, deck: deck)
            let response = try await client.request(endpoint, decode: SaveDeckResponseDTO.self)
            guard response.success else { throw SaveDeckError.rejected(response.message) }
        }
        pendingSave = save
        try await save.value
    }

    func deleteDeck(remoteID: Int) async throws {
        let response = try await client.request(DeleteDeckEndpoint(remoteID: remoteID), decode: SaveDeckResponseDTO.self)
        guard response.success else { throw SaveDeckError.rejected(response.message) }
    }
}
