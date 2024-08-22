//
//  AddToDeckInteractor.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AddToDeckInteractorProtocol {
    func fetchAllCards() async throws -> [CardDTO]
    func cancelRequest()
}

final class AddToDeckInteractor: AddToDeckInteractorProtocol {

    private let service: SWDestinyServiceProtocol
    private var currentRequest: URLRequest?

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func fetchAllCards() async throws -> [CardDTO] {
        let endpoint: SWDestinyEndpoint = .allCards
        let request = endpoint.request

        currentRequest = request

        return try await service.retrieveAllCards(request: request)
    }

    func cancelRequest() {
        service.cancelRequest(currentRequest)
        currentRequest = nil
    }
}
