//
//  LoanDetailViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class LoanDetailViewModel: BaseViewModel {

    var person: PersonDTO
    var lentCards: [CardDTO] = []
    var borrowedCards: [CardDTO] = []
    var showingDeleteConfirmation = false
    var cardToDelete: (card: CardDTO, type: AddCardType)?

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(personId: String, dependencyContainer: DependencyContainer = .shared) {
        person = PersonDTO()
        super.init(dependencyContainer: dependencyContainer)
        loadPerson(byId: personId)
    }

    init(person: PersonDTO, dependencyContainer: DependencyContainer = .shared) {
        self.person = person
        super.init(dependencyContainer: dependencyContainer)
        loadLoanData()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        person = PersonDTO()
        super.init(dependencyContainer: dependencyContainer)
    }

    private func loadPerson(byId personId: String) {
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

    func updateCardQuantity(_ card: CardDTO, newQuantity: Int) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                try await database.update {
                    card.quantity = newQuantity
                }
                self.loadLoanData()
            } catch is CancellationError {
                // Silently cancel
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
        guard let cardToDelete else {
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
        toastTitle = L10n.error
        toastMessage = message
        toastType = .error
        showToast = true
    }
}
