//
//  CardDetailViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class CardDetailViewModelTests: BaseTestCase {

    // MARK: - Properties

    var sut: CardDetailViewModel!
    var mockImageLoader: MockImageLoader!

    override init() async throws {
        try await super.init()
        mockImageLoader = MockImageLoader()
        testContainer.registerMock(ImageLoadingService.self) { [weak self] in
            self?.mockImageLoader ?? MockImageLoader()
        }
    }

    deinit {
        sut = nil
        mockImageLoader = nil
    }

    // MARK: - imageSources Tests

    @Test
    func testImageSourcesWithValidURLs() throws {
        let card1 = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg"
        )
        let card2 = CardDTO.stub(
            code: "01002",
            name: "Kylo Ren",
            imageUrl: "https://swdestinydb.com/bundles/cards/en/01/01002.jpg"
        )

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        let firstExpectedSource = ImageSource.remote(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg")!)
        let secondExpectedSource = ImageSource.remote(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01002.jpg")!)

        #expect(sources.count == 2)
        #expect(sources[0] == firstExpectedSource)
        #expect(sources[1] == secondExpectedSource)
    }

    @Test
    func testImageSourcesWithEmptyURLFallsBackToLocal() {
        let card = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: ""
        )

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        #expect(sources.count == 1)
        #expect(sources[0] == .local(Asset.icCardback.image))
    }

    @Test
    func testImageSourcesWithMalformedURLFallsBackToLocal() {
        let card = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: "not a valid url with spaces"
        )

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        #expect(sources.count == 1)
        #expect(sources[0] == .local(Asset.icCardback.image))
    }

    @Test
    func testImageSourcesMixedValidAndInvalidURLs() throws {
        let validCard = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg"
        )
        let invalidCard = CardDTO.stub(
            code: "01002",
            name: "Kylo Ren",
            imageUrl: ""
        )

        sut = CardDetailViewModel(cards: [validCard, invalidCard], selectedCard: validCard, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        let expectedSource = ImageSource.remote(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg")!)

        #expect(sources.count == 2)
        #expect(sources[0] == expectedSource)
        #expect(sources[1] == .local(Asset.icCardback.image))
    }

    @Test
    func testImageSourcesWithEmptyCards() {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        #expect(sources.isEmpty)
    }

    // MARK: - Initialization Tests

    @Test
    func testInitSetsSelectedCard() {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        #expect(sut.selectedCard.code == "01001")
        #expect(sut.selectedCard.name == "Captain Phasma")
    }

    @Test
    func testInitSetsCurrentIndexToSelectedCard() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card2, dependencyContainer: testContainer.container)

        #expect(sut.currentIndex == 1)
    }

    // MARK: - updateCurrentIndex Tests

    @Test
    func testUpdateCurrentIndexWithValidIndex() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(1)

        #expect(sut.currentIndex == 1)
    }

    @Test
    func testUpdateCurrentIndexWithOutOfBoundsIndex() {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(5)

        #expect(sut.currentIndex == 0)
    }

    // MARK: - currentCard Tests

    @Test
    func testCurrentCardReturnsCorrectCard() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(1)

        #expect(sut.currentCard.code == "01002")
        #expect(sut.currentCard.name == "Kylo Ren")
    }

    // MARK: - imageLoader Tests

    @Test
    func test_imageLoader_resolvedFromDI() {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        #expect(sut.imageLoader is MockImageLoader)
    }

    // MARK: - addToCollection Tests

    @Test
    func test_addToCollection_createsNewCollectionWhenNoneExists() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(stored.count == 1)
        #expect(stored.first?.myCollection.count == 1)
        #expect(stored.first?.myCollection.first?.code == "01001")
    }

    @Test
    func test_addToCollection_addsCardToExistingEmptyCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCollection = UserCollectionDTO.stub()
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(stored.first?.myCollection.count == 1)
        #expect(stored.first?.myCollection.first?.code == "01001")
    }

    @Test
    func test_addToCollection_incrementsQuantityWhenCardAlreadyInCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCard = CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 1)
        let existingCollection = UserCollectionDTO.stub(collection: [existingCard])
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(stored.first?.myCollection.count == 1)
        #expect(stored.first?.myCollection.first?.quantity == 2)
    }

    @Test
    func test_addToCollection_doesNotDuplicateCardInCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCard = CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 3)
        let existingCollection = UserCollectionDTO.stub(collection: [existingCard])
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(stored.first?.myCollection.count == 1, "Should not duplicate — only quantity should increase")
    }

    @Test
    func test_addToCollection_enqueuesToastOnSuccess() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        #expect(sut.toastQueue.current?.title == L10n.added)
        #expect(sut.toastQueue.current?.message == "Captain Phasma")
        #expect(sut.toastQueue.current?.type == .success)
    }

    @Test
    func test_addToCollection_isNotLoadingAfterCompletion() async {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        #expect(sut.isLoading == false)
    }

    @Test
    func test_addToCollection_handlesError() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func test_addToCollection_usesCurrentCardNotSelectedCard() async {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")
        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)
        sut.updateCurrentIndex(1)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(stored.first?.myCollection.first?.code == "01002", "Should add the card at currentIndex, not selectedCard")
    }
}
