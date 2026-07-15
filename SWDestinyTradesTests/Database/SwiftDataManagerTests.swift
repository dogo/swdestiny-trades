//
//  SwiftDataManagerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class SwiftDataManagerTests {

    private var sut: SwiftDataManager!

    init() async throws {
        sut = try await SwiftDataManager.create(inMemory: true)
    }

    deinit {
        sut = nil
    }

    // MARK: - Card round-trip & field mapping

    @Test
    func saveAndFetchByKey_card_mapsAllFields() async throws {
        let card = CardDTO.stub()

        try await sut.save(object: card, update: .all)
        let result = await sut.fetchByKey(CardDTO.self, key: card.id)
        let fetched = try #require(result)

        #expect(fetched.id == card.id)
        #expect(fetched.code == "01001")
        #expect(fetched.name == "Captain Phasma")
        #expect(fetched.subtitle == "Elite Trooper")
        #expect(fetched.setCode == "AW")
        #expect(fetched.typeCode == "character")
        #expect(fetched.factionCode == "red")
        #expect(fetched.affiliationCode == "villain")
        #expect(fetched.rarityCode == "L")
        #expect(fetched.cost == 0)
        #expect(fetched.health == 11)
        #expect(fetched.points == "12/15")
        #expect(fetched.deckLimit == 1)
        #expect(fetched.isUnique == true)
        #expect(fetched.hasDie == true)
        #expect(fetched.cp == 1215)
        #expect(fetched.quantity == 1)
        #expect(fetched.imageUrl == "https://swdestinydb.com/bundles/cards/en/01/01001.jpg")
    }

    @Test
    func fetchByKey_missingCard_returnsNil() async {
        let fetched = await sut.fetchByKey(CardDTO.self, key: "does-not-exist")
        #expect(fetched == nil)
    }

    @Test
    func fetch_returnsAllSavedCards() async throws {
        try await sut.save(object: CardDTO.stub(code: "01001"), update: .all)
        try await sut.save(object: CardDTO.stub(code: "01002"), update: .all)

        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        #expect(cards.count == 2)
    }

    // MARK: - Upsert semantics (no duplicate on same key)

    @Test
    func save_sameId_updatesInsteadOfDuplicating() async throws {
        let card = CardDTO.stub(name: "Captain Phasma")
        try await sut.save(object: card, update: .all)

        card.name = "Updated Name"
        try await sut.save(object: card, update: .all)

        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        #expect(cards.count == 1)
        #expect(cards.first?.name == "Updated Name")
    }

    @Test
    func create_persistsAndReturnsObject() async throws {
        let card = CardDTO.stub(code: "01005")

        let created = try await sut.create(CardDTO.self, value: card, update: .all)

        #expect(created.id == card.id)
        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        #expect(cards.count == 1)
    }

    @Test
    func create_withMismatchedValue_throwsUnsupportedType() async throws {
        do {
            _ = try await sut.create(CardDTO.self, value: SetDTO.stub(), update: .all)
            Issue.record("Expected unsupportedType error")
        } catch let SwiftDataManagerError.unsupportedType(type) {
            #expect(type.contains("CardDTO"))
        }
    }

    // MARK: - Delete

    @Test
    func delete_removesObject() async throws {
        let card = CardDTO.stub()
        try await sut.save(object: card, update: .all)

        try await sut.delete(object: card)

        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        #expect(cards.isEmpty)
    }

    @Test
    func deleteAll_removesOnlyGivenType() async throws {
        try await sut.save(object: CardDTO.stub(), update: .all)
        try await sut.save(object: SetDTO.stub(), update: .all)

        try await sut.deleteAll(CardDTO.self)

        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let sets = await sut.fetch(SetDTO.self, predicate: nil, sorted: nil)
        #expect(cards.isEmpty)
        #expect(sets.count == 1)
    }

    @Test
    func reset_removesEverything() async throws {
        try await sut.save(object: CardDTO.stub(), update: .all)
        try await sut.save(object: SetDTO.stub(), update: .all)
        try await sut.save(object: PersonDTO.stub(), update: .all)

        try await sut.reset()

        let cards = await sut.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let sets = await sut.fetch(SetDTO.self, predicate: nil, sorted: nil)
        let people = await sut.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        #expect(cards.isEmpty)
        #expect(sets.isEmpty)
        #expect(people.isEmpty)
    }

    // MARK: - Sorting

    @Test
    func fetch_sortedByName_ascendingAndDescending() async throws {
        try await sut.save(object: CardDTO.stub(code: "01001", name: "Chewbacca"), update: .all)
        try await sut.save(object: CardDTO.stub(code: "01002", name: "Ackbar"), update: .all)
        try await sut.save(object: CardDTO.stub(code: "01003", name: "Boba Fett"), update: .all)

        let ascending = await sut.fetch(CardDTO.self, predicate: nil, sorted: Sorted(key: "name", ascending: true))
        #expect(ascending.map(\.name) == ["Ackbar", "Boba Fett", "Chewbacca"])

        let descending = await sut.fetch(CardDTO.self, predicate: nil, sorted: Sorted(key: "name", ascending: false))
        #expect(descending.map(\.name) == ["Chewbacca", "Boba Fett", "Ackbar"])
    }

    // MARK: - Set round-trip (code-keyed)

    @Test
    func saveAndFetchByKey_set_usesCodeAsKey() async throws {
        let set = SetDTO.stub(name: "Awakenings", code: "AW")

        try await sut.save(object: set, update: .all)
        let result = await sut.fetchByKey(SetDTO.self, key: "AW")
        let fetched = try #require(result)

        #expect(fetched.code == "AW")
        #expect(fetched.name == "Awakenings")
    }

    // MARK: - Nested relationships

    @Test
    func savePerson_persistsLentAndBorrowedCards() async throws {
        let person = PersonDTO.stub(
            name: "Luke",
            lastName: "Skywalker",
            lentMe: [CardDTO.stub(code: "01001")],
            borrowed: [CardDTO.stub(code: "01002")]
        )

        try await sut.save(object: person, update: .all)
        let result = await sut.fetchByKey(PersonDTO.self, key: person.id)
        let fetched = try #require(result)

        #expect(fetched.name == "Luke")
        #expect(fetched.lastName == "Skywalker")
        #expect(fetched.lentMe.map(\.code) == ["01001"])
        #expect(fetched.borrowed.map(\.code) == ["01002"])
    }

    @Test
    func saveDeck_persistsCardList() async throws {
        let deck = DeckDTO.stub(cards: [CardDTO.stub(code: "01001"), CardDTO.stub(code: "01002")])

        try await sut.save(object: deck, update: .all)
        let result = await sut.fetchByKey(DeckDTO.self, key: deck.id)
        let fetched = try #require(result)

        #expect(fetched.name == "Mock Deck")
        #expect(fetched.list.map(\.code).sorted() == ["01001", "01002"])
    }

    @Test
    func saveUserCollection_persistsCards() async throws {
        let collection = UserCollectionDTO.stub(collection: [CardDTO.stub(code: "01001")])

        try await sut.save(object: collection, update: .all)
        let result = await sut.fetchByKey(UserCollectionDTO.self, key: collection.id)
        let fetched = try #require(result)

        #expect(fetched.myCollection.map(\.code) == ["01001"])
    }

    // MARK: - Observe

    @Test
    func observe_emitsInitialState() async throws {
        try await sut.save(object: CardDTO.stub(code: "01001"), update: .all)

        var iterator = sut.observe(CardDTO.self, predicate: nil, sorted: nil).makeAsyncIterator()
        let firstEmission = await iterator.next()

        #expect(firstEmission?.map(\.code) == ["01001"])
    }
}
