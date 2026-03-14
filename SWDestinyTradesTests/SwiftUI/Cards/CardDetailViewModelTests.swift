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

    override func tearDown() async throws {
        sut = nil
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
}
