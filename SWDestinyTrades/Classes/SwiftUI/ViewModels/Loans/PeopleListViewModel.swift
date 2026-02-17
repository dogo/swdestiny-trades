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
    static let personDeleted = Notification.Name("personDeleted")
}

@MainActor
@Observable
final class PeopleListViewModel: ListViewModel<PersonDTO> {

    var showingDeleteConfirmation = false
    var personToDelete: PersonDTO?

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.showToast = false

            self.toastTitle = "Error"
            self.toastMessage = error.localizedDescription
            self.toastType = .error

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showToast = true
            }

            self.setLoaded()
        }
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        loadPeople()
    }

    func loadPeople() {
        setLoading(true)
        loadPeopleFromDatabase()
    }

    private func loadPeopleFromDatabase() {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)
            let peopleArray = Array(people)
            self.updateItems(peopleArray)
            self.setLoaded()
        }
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

    func prepareToDelete(_ person: PersonDTO) {
        personToDelete = person
        showingDeleteConfirmation = true
    }

    func confirmDelete() {
        guard let person = personToDelete,
              let database else {
            return
        }

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
                self.personToDelete = nil
                self.showingDeleteConfirmation = false

                NotificationCenter.default.post(name: .personDeleted, object: person)
            } catch {
                self.handleError(error)
            }
        }
    }

    func confirmDelete(person: PersonDTO) {
        guard let database else {
            return
        }

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

                NotificationCenter.default.post(name: .personDeleted, object: person)
            } catch {
                self.handleError(error)
            }
        }
    }

    func cancelDelete() {
        personToDelete = nil
        showingDeleteConfirmation = false
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
