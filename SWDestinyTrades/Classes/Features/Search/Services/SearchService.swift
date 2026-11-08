//
//  SearchService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class SearchService: SearchServiceProtocol {

    private let client: HttpClientProtocol

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func search(query: String) async throws -> [CardDTO] {
        let endpoint = SearchEndpoint(query: query)

        return try await client.request(endpoint, decode: [CardDTO].self)
    }
}
