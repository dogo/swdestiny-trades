//
//  SetService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class SetService: SetServiceProtocol {

    private let client: HttpClientProtocol

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func retrieveSetList() async throws -> [SetDTO] {
        let endpoint = SetListEndpoint()

        return try await client.request(endpoint, decode: [SetDTO].self)
    }
}
