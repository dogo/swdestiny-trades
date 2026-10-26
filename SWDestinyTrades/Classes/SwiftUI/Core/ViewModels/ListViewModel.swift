//
//  ListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
class ListViewModel<T: Identifiable>: BaseViewModel {
    private(set) var items: [T] = []
    private(set) var filteredItems: [T] = []

    var searchText = ""

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    func performFiltering(searchText: String) {
        self.searchText = searchText
        filteredItems = filterItems(searchText: searchText)
    }

    func filterItems(searchText: String) -> [T] {
        if searchText.isEmpty {
            return items
        }
        assertionFailure("ListViewModel subclasses must override filterItems(searchText:) to implement filtering.")
        return items
    }

    func loadItems(page: Int = 0, reset: Bool = false) async {
        // Override in subclasses
    }

    func refresh() async {
        await loadItems(page: 0, reset: true)
    }

    func updateItems(_ newItems: [T]) {
        items = newItems
        filteredItems = filterItems(searchText: searchText)
    }
}
