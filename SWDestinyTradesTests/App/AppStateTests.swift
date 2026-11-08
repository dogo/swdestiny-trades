//
//  AppStateTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class AppStateTests {

    @Test
    func initialize_registersServicesBeforeTheDatabaseIsReady() {
        let container = TestContainer().container
        let sut = AppState(dependencyContainer: container, makeDatabase: { DatabaseMock() })

        sut.initialize()

        #expect(sut.isInitialized == false)
        #expect(container.resolve(type: HttpClientProtocol.self) is AuthenticatedHttpClient)
        _ = container.resolve(type: AuthServiceProtocol.self)
        _ = container.resolve(type: CardServiceProtocol.self)
        _ = container.resolve(type: SetServiceProtocol.self)
        _ = container.resolve(type: SearchServiceProtocol.self)
        _ = container.resolve(type: DeckServiceProtocol.self)
        _ = container.resolve(type: ImageLoadingService.self)
    }
}
