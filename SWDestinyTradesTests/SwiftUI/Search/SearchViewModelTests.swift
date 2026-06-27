//
//  SearchViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class SearchViewModelTests: BaseTestCase {

    private var sut: SearchViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = SearchViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Search

    func test_performSearch_populatesResults() async {
        mockSWDestinyService.searchResult = [
            CardDTO.stub(code: "01001", name: "Luke Skywalker"),
            CardDTO.stub(code: "01002", name: "Luke's Lightsaber")
        ]

        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.isLoading && self.sut.hasSearched && !self.sut.searchResults.isEmpty }

        XCTAssertEqual(sut.searchResults.count, 2)
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.currentQuery, "Luke")
        XCTAssertTrue(sut.hasSearched)
    }

    func test_performSearch_blankQuery_clearsSearch() {
        sut.performSearch(query: "   ")

        XCTAssertFalse(sut.hasSearched)
        XCTAssertTrue(sut.searchResults.isEmpty)
    }

    func test_performSearch_onError_clearsResultsAndShowsErrorToast() async {
        mockSWDestinyService.searchError = APIError.invalidData

        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.isLoading && self.sut.toastQueue.current != nil }

        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    func test_clearSearch_resetsState() async {
        mockSWDestinyService.searchResult = [CardDTO.stub(code: "01001")]
        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.searchResults.isEmpty }

        sut.clearSearch()

        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertEqual(sut.currentQuery, "")
        XCTAssertFalse(sut.hasSearched)
    }

    func test_filterItems_returnsSearchResults() async {
        mockSWDestinyService.searchResult = [CardDTO.stub(code: "01001")]
        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.searchResults.isEmpty }

        XCTAssertEqual(sut.filterItems(searchText: "anything").map(\.code), ["01001"])
    }

    // MARK: - Suggestions

    func test_getSearchSuggestions_emptyText_returnsAll() {
        sut.searchText = ""

        XCTAssertFalse(sut.getSearchSuggestions().isEmpty)
    }

    func test_getSearchSuggestions_filtersByText() {
        sut.searchText = "Luke"

        XCTAssertEqual(sut.getSearchSuggestions(), ["Luke Skywalker"])
    }

    // MARK: - View state flags

    func test_shouldShowInitialState_onFreshViewModel() {
        XCTAssertTrue(sut.shouldShowInitialState)
        XCTAssertFalse(sut.shouldShowSuggestions)
    }

    func test_shouldShowSuggestions_whenShortQueryNotYetSearched() {
        sut.searchText = "Lu"

        XCTAssertTrue(sut.shouldShowSuggestions)
    }

    func test_shouldShowEmptyState_afterSearchWithNoResults() async {
        mockSWDestinyService.searchResult = []

        sut.performSearch(query: "Nonexistent")
        await waitUntil { !self.sut.isLoading && self.sut.hasSearched }

        XCTAssertTrue(sut.shouldShowEmptyState)
    }
}
