//
//  PeopleListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

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
        toastTitle = L10n.error
        toastMessage = error.localizedDescription
        toastType = .error

        showToast = true
        setLoaded()
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
        var filteredPeople = items

        if !searchText.isEmpty {
            filteredPeople = filteredPeople.filter { person in
                person.name.localizedCaseInsensitiveContains(searchText) ||
                    person.lastName.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort by name by default
        filteredPeople = filteredPeople.sorted { $0.name < $1.name }

        return filteredPeople
    }

    func createNewPerson() {}

    func viewPersonDetails(_ person: PersonDTO) {}

    func deletePerson(_ person: PersonDTO) async {
        do {
            let personId = person.id
            let allItemIds = items.map(\.id)

            try await database.delete(object: person)

            let remainingIds = allItemIds.filter { $0 != personId }

            let freshPeople = await database.fetch(
                PersonDTO.self,
                predicate: NSPredicate(format: "id IN %@", remainingIds),
                sorted: nil
            )

            updateItems(Array(freshPeople))

            toastTitle = L10n.deletedPerson
            toastMessage = L10n.personDeletedSuccessfully(person.name, person.lastName)
            toastType = .success
            showToast = true
        } catch {
            handleError(error)
        }
    }

    func getLoanSummary(for person: PersonDTO) -> LoanSummary {
        return LoanSummary(
            borrowedCount: person.borrowedCount,
            lentCount: person.lentCount,
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
