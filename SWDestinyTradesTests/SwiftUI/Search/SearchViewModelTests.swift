//
//  SearchViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class SearchViewModelTests: BaseTestCase {

    private var sut: SearchViewModel!

    override init() async throws {
        try await super.init()
        sut = SearchViewModel(dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
    }

    // MARK: - Search

    @Test
    func performSearch_populatesResults() async {
        mockSWDestinyService.searchResult = [
            CardDTO.stub(code: "01001", name: "Luke Skywalker"),
            CardDTO.stub(code: "01002", name: "Luke's Lightsaber")
        ]

        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.isLoading && self.sut.hasSearched && !self.sut.searchResults.isEmpty }

        #expect(sut.searchResults.count == 2)
        #expect(sut.items.count == 2)
        #expect(sut.currentQuery == "Luke")
        #expect(sut.hasSearched)
    }

    @Test
    func performSearch_blankQuery_clearsSearch() {
        sut.performSearch(query: "   ")

        #expect(sut.hasSearched == false)
        #expect(sut.searchResults.isEmpty)
    }

    @Test
    func performSearch_onError_clearsResultsAndShowsErrorToast() async {
        mockSWDestinyService.searchError = APIError.invalidData

        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.isLoading && self.sut.toastQueue.current != nil }

        #expect(sut.searchResults.isEmpty)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func clearSearch_resetsState() async {
        mockSWDestinyService.searchResult = [CardDTO.stub(code: "01001")]
        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.searchResults.isEmpty }

        sut.clearSearch()

        #expect(sut.searchResults.isEmpty)
        #expect(sut.currentQuery.isEmpty)
        #expect(sut.hasSearched == false)
    }

    @Test
    func filterItems_returnsSearchResults() async {
        mockSWDestinyService.searchResult = [CardDTO.stub(code: "01001")]
        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.searchResults.isEmpty }

        #expect(sut.filterItems(searchText: "anything").map(\.code) == ["01001"])
    }

    // MARK: - Suggestions

    @Test
    func getSearchSuggestions_emptyText_returnsAll() {
        sut.searchText = ""

        #expect(sut.getSearchSuggestions().isEmpty == false)
    }

    @Test
    func getSearchSuggestions_filtersByText() {
        sut.searchText = "Luke"

        #expect(sut.getSearchSuggestions() == ["Luke Skywalker"])
    }

    // MARK: - View state flags

    @Test
    func shouldShowInitialState_onFreshViewModel() {
        #expect(sut.shouldShowInitialState)
        #expect(sut.shouldShowSuggestions == false)
    }

    @Test
    func shouldShowSuggestions_whenShortQueryNotYetSearched() {
        sut.searchText = "Lu"

        #expect(sut.shouldShowSuggestions)
    }

    @Test
    func shouldShowEmptyState_afterSearchWithNoResults() async {
        mockSWDestinyService.searchResult = []

        sut.performSearch(query: "Nonexistent")
        await waitUntil { !self.sut.isLoading && self.sut.hasSearched }

        #expect(sut.shouldShowEmptyState)
    }
}
