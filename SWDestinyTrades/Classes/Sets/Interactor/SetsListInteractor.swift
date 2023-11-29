//
//  SetsListInteractor.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SetsInteractorProtocol {
    func retrieveSets() async throws -> [SetDTO]
}

final class SetsListInteractor: SetsInteractorProtocol {

    private let service: SWDestinyServiceProtocol

    init(service: SWDestinyServiceProtocol = SWDestinyService()) {
        self.service = service
    }

    func retrieveSets() async throws -> [SetDTO] {
        return try await service.retrieveSetList()
    }
}
