//
//  CardDetailViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class CardDetailViewModelTests: BaseTestCase {

    // MARK: - Properties

    var sut: CardDetailViewModel!
    var mockImageLoader: MockImageLoader!

    override func setUp() async throws {
        try await super.setUp()
        mockImageLoader = MockImageLoader()
        testContainer.registerMock(ImageLoadingService.self) { [weak self] in
            self?.mockImageLoader ?? MockImageLoader()
        }
    }

    override func tearDown() async throws {
        sut = nil
        mockImageLoader = nil
        try await super.tearDown()
    }

    // MARK: - imageSources Tests

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

        XCTAssertEqual(sources.count, 2)
        XCTAssertEqual(sources[0], try .remote(XCTUnwrap(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))))
        XCTAssertEqual(sources[1], try .remote(XCTUnwrap(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01002.jpg"))))
    }

    func testImageSourcesWithEmptyURLFallsBackToLocal() {
        let card = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: ""
        )

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources[0], .local(Asset.icCardback.image))
    }

    func testImageSourcesWithMalformedURLFallsBackToLocal() {
        let card = CardDTO.stub(
            code: "01001",
            name: "Captain Phasma",
            imageUrl: "not a valid url with spaces"
        )

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources[0], .local(Asset.icCardback.image))
    }

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

        XCTAssertEqual(sources.count, 2)
        XCTAssertEqual(sources[0], try .remote(XCTUnwrap(URL(string: "https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))))
        XCTAssertEqual(sources[1], .local(Asset.icCardback.image))
    }

    func testImageSourcesWithEmptyCards() {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [], selectedCard: card, dependencyContainer: testContainer.container)

        let sources = sut.imageSources

        XCTAssertTrue(sources.isEmpty)
    }

    // MARK: - Initialization Tests

    func testInitSetsSelectedCard() {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        XCTAssertEqual(sut.selectedCard.code, "01001")
        XCTAssertEqual(sut.selectedCard.name, "Captain Phasma")
    }

    func testInitSetsCurrentIndexToSelectedCard() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card2, dependencyContainer: testContainer.container)

        XCTAssertEqual(sut.currentIndex, 1)
    }

    // MARK: - updateCurrentIndex Tests

    func testUpdateCurrentIndexWithValidIndex() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(1)

        XCTAssertEqual(sut.currentIndex, 1)
    }

    func testUpdateCurrentIndexWithOutOfBoundsIndex() {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(5)

        XCTAssertEqual(sut.currentIndex, 0)
    }

    // MARK: - currentCard Tests

    func testCurrentCardReturnsCorrectCard() {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")

        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)

        sut.updateCurrentIndex(1)

        XCTAssertEqual(sut.currentCard.code, "01002")
        XCTAssertEqual(sut.currentCard.name, "Kylo Ren")
    }

    // MARK: - imageLoader Tests

    func test_imageLoader_resolvedFromDI() {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        XCTAssertTrue(sut.imageLoader is MockImageLoader)
    }

    // MARK: - addToCollection Tests

    func test_addToCollection_createsNewCollectionWhenNoneExists() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(stored.count, 1)
        XCTAssertEqual(stored.first?.myCollection.count, 1)
        XCTAssertEqual(stored.first?.myCollection.first?.code, "01001")
    }

    func test_addToCollection_addsCardToExistingEmptyCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCollection = UserCollectionDTO.stub()
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(stored.first?.myCollection.count, 1)
        XCTAssertEqual(stored.first?.myCollection.first?.code, "01001")
    }

    func test_addToCollection_incrementsQuantityWhenCardAlreadyInCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCard = CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 1)
        let existingCollection = UserCollectionDTO.stub(collection: [existingCard])
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(stored.first?.myCollection.count, 1)
        XCTAssertEqual(stored.first?.myCollection.first?.quantity, 2)
    }

    func test_addToCollection_doesNotDuplicateCardInCollection() async throws {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let existingCard = CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 3)
        let existingCollection = UserCollectionDTO.stub(collection: [existingCard])
        try await testDatabase.save(object: existingCollection, update: .all)

        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(stored.first?.myCollection.count, 1, "Should not duplicate — only quantity should increase")
    }

    func test_addToCollection_enqueuesToastOnSuccess() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        XCTAssertEqual(sut.toastQueue.current?.title, L10n.added)
        XCTAssertEqual(sut.toastQueue.current?.message, "Captain Phasma")
        XCTAssertEqual(sut.toastQueue.current?.type, .success)
    }

    func test_addToCollection_isNotLoadingAfterCompletion() async {
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        XCTAssertFalse(sut.isLoading)
    }

    func test_addToCollection_handlesError() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        let card = CardDTO.stub()
        sut = CardDetailViewModel(cards: [card], selectedCard: card, dependencyContainer: testContainer.container)

        await sut.addToCollection()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    func test_addToCollection_usesCurrentCardNotSelectedCard() async {
        let card1 = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let card2 = CardDTO.stub(code: "01002", name: "Kylo Ren")
        sut = CardDetailViewModel(cards: [card1, card2], selectedCard: card1, dependencyContainer: testContainer.container)
        sut.updateCurrentIndex(1)

        await sut.addToCollection()

        let stored = await testDatabase.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(stored.first?.myCollection.first?.code, "01002", "Should add the card at currentIndex, not selectedCard")
    }
}
