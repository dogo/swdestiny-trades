//
//  CardListInteractor.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol CardListInteractorProtocol {
    func retrieveCards(setCode: String) async throws -> [CardDTO]
}

final class CardListInteractor: CardListInteractorProtocol {

    private let service: SWDestinyServiceProtocol

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func retrieveCards(setCode: String) async throws -> [CardDTO] {
        return try await service.retrieveSetCardList(setCode: setCode)
    }
}
