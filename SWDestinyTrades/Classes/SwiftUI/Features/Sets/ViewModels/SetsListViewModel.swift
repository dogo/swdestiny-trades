//
//  SetsListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class SetsListViewModel: ListViewModel<SetDTO> {

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        setLoading(true)
        await fetchSetsFromAPI()
    }

    private func fetchSetsFromAPI() async {
        do {
            try Task.checkCancellation()

            let sets = try await service.retrieveSetList()

            try Task.checkCancellation()

            for set in sets {
                try await database.save(object: set, update: .modified)
            }

            updateItems(sets)
            setLoaded()
        } catch is CancellationError {
            setLoaded()
        } catch {
            handleError(error)
        }
    }

    func refreshSets() async {
        setLoading(true)
        do {
            let sets = try await service.retrieveSetList()

            for set in sets {
                try await database.save(object: set, update: .modified)
            }

            updateItems(sets)
            setLoaded()
        } catch is CancellationError {
            setLoaded()
        } catch {
            handleError(error)
        }
    }

    override func filterItems(searchText: String) -> [SetDTO] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { set in
                set.name.localizedStandardContains(searchText) ||
                    set.code.localizedStandardContains(searchText)
            }
        }
    }

    override func handleError(_ error: Error) {
        guard !ConcurrencyError.isCancellation(error) else { return }
        super.handleError(error)
    }
}
