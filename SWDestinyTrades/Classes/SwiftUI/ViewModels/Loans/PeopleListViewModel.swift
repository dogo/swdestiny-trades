//
//  PeopleListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

extension Notification.Name {
    static let personAdded = Notification.Name("personAdded")
}

@MainActor
@Observable
final class PeopleListViewModel: ListViewModel<PersonDTO> {

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.showToast = false

            self.toastTitle = L10n.error
            self.toastMessage = error.localizedDescription
            self.toastType = .error

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showToast = true
            }

            self.setLoaded()
        }
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        await loadPeople()
    }

    func loadPeople() async {
        setLoading(true)
        await loadPeopleFromDatabase()
    }

    private func loadPeopleFromDatabase() async {
        let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        let peopleArray = Array(people)
        updateItems(peopleArray)
        setLoaded()
    }

    override func filterItems(searchText: String) -> [PersonDTO] {
        let peopleData = items.threadSafeMap { $0.toThreadSafe() }

        var filteredData = peopleData

        if !searchText.isEmpty {
            filteredData = filteredData.filter { personData in
                personData.name.localizedCaseInsensitiveContains(searchText) ||
                    personData.lastName.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort by name by default
        filteredData = filteredData.sorted { $0.name < $1.name }

        let filteredPeople = filteredData.compactMap { personData in
            items.first { $0.id == personData.id }
        }

        return filteredPeople
    }

    func createNewPerson() {}

    func viewPersonDetails(_ person: PersonDTO) {}

    func deletePerson(_ person: PersonDTO) {
        let personData = person.toThreadSafe()

        Task { @MainActor in
            do {
                let itemsData = self.items.threadSafeMap { $0.toThreadSafe() }

                try await database.delete(object: person)

                let filteredData = itemsData.filter { $0.id != personData.id }

                let newItems = filteredData.compactMap { personData in
                    self.items.first { $0.id == personData.id }
                }

                self.updateItems(newItems)

                self.toastTitle = L10n.deletedPerson
                self.toastMessage = L10n.personDeletedSuccessfully(personData.name, personData.lastName)
                self.toastType = .success
                self.showToast = true
            } catch {
                self.handleError(error)
            }
        }
    }

    func getLoanSummary(for person: PersonDTO) -> LoanSummary {
        let personData = person.toThreadSafe()

        return LoanSummary(
            borrowedCount: personData.borrowedCount,
            lentCount: personData.lentCount,
            totalValue: 0.0
        )
    }
}

struct LoanSummary {
    let borrowedCount: Int
    let lentCount: Int
    let totalValue: Double

    var hasLoans: Bool {
        return borrowedCount > 0 || lentCount > 0
    }
}
