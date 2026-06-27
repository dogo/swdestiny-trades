//
//  PreviewHelperTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class PreviewHelperTests {

    @Test
    func test_createMockDatabase_populatesSampleData() async throws {
        let database = try await PreviewHelper.createMockDatabase()

        let cards = await database.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let sets = await database.fetch(SetDTO.self, predicate: nil, sorted: nil)
        let decks = await database.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)

        #expect(Set(cards.map(\.code)).isSuperset(of: Set(SampleData.cards.map(\.code))))
        #expect(sets.map(\.code).sorted() == SampleData.sets.map(\.code).sorted())
        #expect(decks.map(\.name).sorted() == SampleData.decks.map(\.name).sorted())
        #expect(people.map(\.name).sorted() == SampleData.people.map(\.name).sorted())
        #expect(decks.allSatisfy { !$0.list.isEmpty })
        #expect(people.allSatisfy { !$0.lentMe.isEmpty || !$0.borrowed.isEmpty })
    }

    @Test
    func test_createAppState_marksInitializedAndAttachesDatabase() async throws {
        let appState = try await PreviewHelper.createAppState()
        let database = try #require(appState.database)
        let cards = await database.fetch(CardDTO.self, predicate: nil, sorted: nil)

        #expect(appState.isInitialized)
        #expect(!appState.isLoading)
        #expect(Set(cards.map(\.code)).isSuperset(of: Set(SampleData.cards.map(\.code))))
    }

    @Test
    func test_previewHttpClientMock_requestThrowsInvalidData() async throws {
        let sut = PreviewHttpClientMock()
        let url = try #require(URL(string: "https://example.com/cards"))
        let request = URLRequest(url: url)

        do {
            let _: SetDTO = try await sut.request(request, decode: SetDTO.self)
            Issue.record("Expected PreviewHttpClientMock to throw invalidData")
        } catch let error as APIError {
            #expect(error == .invalidData)
        } catch {
            Issue.record("Expected APIError.invalidData, got \(error)")
        }
    }
}
