//
//  ListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

private struct Item: Identifiable, Equatable {
    let id: Int
    let name: String
}

@MainActor
private final class NameListViewModel: ListViewModel<Item> {
    private(set) var loadCalls: [(page: Int, reset: Bool)] = []

    override func filterItems(searchText: String) -> [Item] {
        searchText.isEmpty ? items : items.filter { $0.name.contains(searchText) }
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        loadCalls.append((page, reset))
    }
}

@MainActor
final class ListViewModelTests {

    private let sut = NameListViewModel()

    @Test
    func updateItems_replacesItemsAndFilteredItems() {
        sut.updateItems([Item(id: 1, name: "Rey")])
        sut.updateItems([Item(id: 2, name: "Finn")])

        #expect(sut.items == [Item(id: 2, name: "Finn")])
        #expect(sut.filteredItems == [Item(id: 2, name: "Finn")])
    }

    @Test
    func performFiltering_storesSearchTextAndFilters() {
        sut.updateItems([Item(id: 1, name: "Rey"), Item(id: 2, name: "Finn")])

        sut.performFiltering(searchText: "Fi")

        #expect(sut.searchText == "Fi")
        #expect(sut.filteredItems == [Item(id: 2, name: "Finn")])
        #expect(sut.items.count == 2)
    }

    @Test
    func updateItems_keepsCurrentSearchApplied() {
        sut.performFiltering(searchText: "Rey")

        sut.updateItems([Item(id: 1, name: "Rey"), Item(id: 2, name: "Finn")])

        #expect(sut.filteredItems == [Item(id: 1, name: "Rey")])
    }

    @Test
    func refresh_reloadsFirstPageWithReset() async {
        await sut.refresh()

        #expect(sut.loadCalls.count == 1)
        #expect(sut.loadCalls.first?.page == 0)
        #expect(sut.loadCalls.first?.reset == true)
    }

    @Test
    func baseFilterItems_withEmptySearch_returnsAllItems() {
        let base = ListViewModel<Item>()
        base.updateItems([Item(id: 1, name: "Rey")])

        #expect(base.filterItems(searchText: "") == [Item(id: 1, name: "Rey")])
    }
}
