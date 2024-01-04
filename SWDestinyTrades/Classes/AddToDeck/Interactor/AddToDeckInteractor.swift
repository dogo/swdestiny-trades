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
    func cancelAllRequests()
}

final class AddToDeckInteractor: AddToDeckInteractorProtocol {

    private let service: SWDestinyServiceProtocol

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func fetchAllCards() async throws -> [CardDTO] {
        return try await service.retrieveAllCards()
    }

    func cancelAllRequests() {
        service.cancelAllRequests()
    }
}
