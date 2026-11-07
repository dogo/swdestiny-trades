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

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func retrieveDecks() async throws -> [DeckDTO] {
        let endpoint = DecksEndpoint()

        return try await client.request(endpoint, decode: [RemoteDeckDTO].self).map(\.deck)
    }
}
