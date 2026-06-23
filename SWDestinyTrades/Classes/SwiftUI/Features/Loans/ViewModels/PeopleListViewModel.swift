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

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)
        setLoaded()
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        await loadPeople()
    }

    func loadPeople() async {
        setLoading(true)
        loadPeopleFromDatabase()
    }

    private func loadPeopleFromDatabase() {
        observationTask?.cancel()

        observationTask = Task { @MainActor in
            let peopleStream = database.observe(PersonDTO.self, predicate: nil, sorted: nil)

            for await people in peopleStream {
                guard !Task.isCancelled else { break }

                updateItems(Array(people))
                setLoaded()
            }
        }
    }

    override func filterItems(searchText: String) -> [PersonDTO] {
        var filteredPeople = items

        if !searchText.isEmpty {
            filteredPeople = filteredPeople.filter { person in
                person.name.localizedStandardContains(searchText) ||
                    person.lastName.localizedStandardContains(searchText)
            }
        }

        // Sort by name by default
        filteredPeople = filteredPeople.sorted { $0.name < $1.name }

        return filteredPeople
    }

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

            toastQueue.enqueue(
                title: L10n.deletedPerson,
                message: L10n.personDeletedSuccessfully(person.name, person.lastName),
                type: .success
            )
        } catch {
            handleError(error)
        }
    }

    func getLoanSummary(for person: PersonDTO) -> LoanSummary {
        return LoanSummary(
            borrowedCount: person.borrowed.reduce(0) { $0 + $1.quantity },
            lentCount: person.lentMe.reduce(0) { $0 + $1.quantity },
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
