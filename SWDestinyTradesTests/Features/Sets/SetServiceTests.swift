//
//  SetServiceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class SetServiceTests: BaseTestCase {

    private var sut: SetService!

    override init() async throws {
        try await super.init()
        sut = SetService(client: mockHttpClient)
    }

    @Test
    func retrieveSetListWithSuccess() async throws {
        mockHttpClient.fileName = "sets"
        let result = try await sut.retrieveSetList()

        #expect(result.isEmpty == false)
    }
}
