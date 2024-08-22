//
//  AddCardInteractor.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AddCardInteractorProtocol {
    func retrieveAllCards() async throws -> [CardDTO]
}

final class AddCardInteractor: AddCardInteractorProtocol {

    private let service: SWDestinyServiceProtocol

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func retrieveAllCards() async throws -> [CardDTO] {
        return try await service.retrieveAllCards()
    }
}
