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
        mockSearchService.searchResult = [
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
    func performSearch_duringDebounce_searchesOnce() async throws {
        sut.onSearchTextChanged("Luke")
        sut.performSearch(query: "Luke")

        try await Task.sleep(for: .milliseconds(700))

        #expect(mockSearchService.searchCallCount == 1)
    }

    @Test
    func performSearch_newSearch_cancelsTheOneInFlight() async {
        mockSearchService.delay = .milliseconds(300)
        mockSearchService.searchResult = [CardDTO.stub(code: "01001")]

        sut.performSearch(query: "Luke")
        await waitUntil { self.mockSearchService.searchCallCount == 1 }
        sut.performSearch(query: "Leia")
        await waitUntil { self.mockSearchService.searchCallCount == 2 && !self.sut.isLoading }

        #expect(mockSearchService.cancelledCount == 1)
        #expect(sut.currentQuery == "Leia")
        #expect(sut.searchResults.count == 1)
    }

    @Test
    func clearSearch_cancelsSearchInFlight() async {
        mockSearchService.delay = .milliseconds(300)
        mockSearchService.searchResult = [CardDTO.stub(code: "01001")]

        sut.performSearch(query: "Luke")
        await waitUntil { self.mockSearchService.searchCallCount == 1 }
        sut.clearSearch()
        await waitUntil { self.mockSearchService.cancelledCount == 1 }
        try? await Task.sleep(for: .milliseconds(400))

        #expect(mockSearchService.cancelledCount == 1)
        #expect(sut.searchResults.isEmpty)
        #expect(sut.hasSearched == false)
    }

    @Test
    func performSearch_blankQuery_clearsSearch() {
        sut.performSearch(query: "   ")

        #expect(sut.hasSearched == false)
        #expect(sut.searchResults.isEmpty)
    }

    @Test
    func performSearch_onError_clearsResultsAndShowsErrorToast() async {
        mockSearchService.searchError = APIError.invalidData

        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.isLoading && self.sut.toastQueue.current != nil }

        #expect(sut.searchResults.isEmpty)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func clearSearch_resetsState() async {
        mockSearchService.searchResult = [CardDTO.stub(code: "01001")]
        sut.performSearch(query: "Luke")
        await waitUntil { !self.sut.searchResults.isEmpty }

        sut.clearSearch()

        #expect(sut.searchResults.isEmpty)
        #expect(sut.currentQuery.isEmpty)
        #expect(sut.hasSearched == false)
    }

    @Test
    func filterItems_returnsSearchResults() async {
        mockSearchService.searchResult = [CardDTO.stub(code: "01001")]
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
        mockSearchService.searchResult = []

        sut.performSearch(query: "Nonexistent")
        await waitUntil { !self.sut.isLoading && self.sut.hasSearched }

        #expect(sut.shouldShowEmptyState)
    }
}
