//
//  SearchListInteractor.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SearchListInteractorProtocol {
    func search(query: String) async throws -> [CardDTO]
}

final class SearchListInteractor: SearchListInteractorProtocol {

    private let service: SWDestinyServiceProtocol

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func search(query: String) async throws -> [CardDTO] {
        return try await service.search(query: query)
    }
}
