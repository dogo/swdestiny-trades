//
//  LoanDetailViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class LoanDetailViewModel: BaseViewModel {

    @Published var person: PersonDTO
    @Published var lentCards: [CardDTO] = []
    @Published var borrowedCards: [CardDTO] = []
    @Published var showingDeleteConfirmation = false
    @Published var cardToDelete: (card: CardDTO, type: AddCardType)?

    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(personId: String, dependencyContainer: DependencyContainer = .shared) {
        person = PersonDTO()
        super.init(dependencyContainer: dependencyContainer)
        loadPerson(byId: personId)
        setupNotifications()
    }

    init(person: PersonDTO, dependencyContainer: DependencyContainer = .shared) {
        self.person = person
        super.init(dependencyContainer: dependencyContainer)
        loadLoanData()
        setupNotifications()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        person = PersonDTO()
        super.init(dependencyContainer: dependencyContainer)
    }

    private func loadPerson(byId personId: String) {
        guard let database else {
            showErrorToast(ViewModelError.databaseNotAvailable.localizedDescription)
            return
        }

        Task { @MainActor in
            let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)
            if let foundPerson = people.first(where: { $0.id == personId }) {
                self.person = foundPerson
                self.loadLoanData()
            }
        }
    }

    func loadLoanData() {
        lentCards = Array(person.lentMe)
        borrowedCards = Array(person.borrowed)
    }

    private func setupNotifications() {
        NotificationCenter.default.publisher(for: NotificationKey.reloadTableViewNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self else { return }
                if let personDTO = notification.userInfo?["personDTO"] as? PersonDTO {
                    person = personDTO
                    loadLoanData()
                }
            }
            .store(in: &cancellables)
    }

    func updateCardQuantity(_ card: CardDTO, newQuantity: Int) {
        guard let database else {
            showErrorToast(ViewModelError.databaseNotAvailable.localizedDescription)
            return
        }

        Task { @MainActor in
            do {
                try await database.update {
                    card.quantity = newQuantity
                }
                self.loadLoanData()
            } catch {
                self.showErrorToast(error.localizedDescription)
            }
        }
    }

    func prepareToDelete(_ card: CardDTO, type: AddCardType) {
        cardToDelete = (card, type)
        showingDeleteConfirmation = true
    }

    func confirmDelete() {
        guard let cardToDelete,
              let database else {
            return
        }

        Task { @MainActor in
            do {
                try await database.update { [weak self] in
                    switch cardToDelete.type {
                    case .lent:
                        if let index = self?.person.lentMe.firstIndex(of: cardToDelete.card) {
                            self?.person.lentMe.remove(at: index)
                        }
                    case .borrow:
                        if let index = self?.person.borrowed.firstIndex(of: cardToDelete.card) {
                            self?.person.borrowed.remove(at: index)
                        }
                    default:
                        break
                    }
                }

                self.loadLoanData()
                NotificationCenter.default.post(
                    name: NotificationKey.reloadTableViewNotification,
                    object: nil,
                    userInfo: nil
                )

                self.cardToDelete = nil
                self.showingDeleteConfirmation = false
            } catch {
                self.showErrorToast(error.localizedDescription)
            }
        }
    }

    func cancelDelete() {
        cardToDelete = nil
        showingDeleteConfirmation = false
    }

    var personFullName: String {
        return "\(person.name) \(person.lastName)"
    }

    var hasLoans: Bool {
        return !lentCards.isEmpty || !borrowedCards.isEmpty
    }

    var loanSummary: LoanSummary {
        return LoanSummary(
            borrowedCount: borrowedCards.count,
            lentCount: lentCards.count,
            totalValue: 0.0
        )
    }

    private func showErrorToast(_ message: String) {
        toastTitle = "Error"
        toastMessage = message
        toastType = .error
        showToast = true
    }
}
