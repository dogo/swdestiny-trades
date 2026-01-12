//
//  SetsListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class SetsListViewModel: ListViewModel<SetDTO> {

    // Toast properties
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var swDestinyService: SWDestinyServiceProtocol? {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        loadItems()
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        setLoading(true)
        fetchSetsFromAPI()
    }

    private func fetchSetsFromAPI() {
        guard let service = swDestinyService else {
            handleError(ViewModelError.serviceNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let sets = try await service.retrieveSetList()

                try Task.checkCancellation()

                self.updateItems(sets)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(error)
            }
        }
    }

    func refreshSets() async {
        setLoading(true)
        guard let service = swDestinyService else {
            handleError(ViewModelError.serviceNotAvailable)
            return
        }

        do {
            try Task.checkCancellation()

            let sets = try await service.retrieveSetList()

            try Task.checkCancellation()

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
                set.name.localizedCaseInsensitiveContains(searchText) ||
                    set.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        showToast = false

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = "Error"
        toastMessage = L10n.errorMessage
        toastType = .error

        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
            } catch {
                // Ignore cancellation during toast delay
            }
        }
    }
}
