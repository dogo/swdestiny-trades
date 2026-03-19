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

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(personId: String, dependencyContainer: DependencyContainer = .shared) {
        person = PersonDTO()
        super.init(dependencyContainer: dependencyContainer)
        loadPerson(byId: personId)
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
                await self.loadLoanData()
            }
        }
    }

    func loadLoanData() async {
        let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        if let freshPerson = people.first(where: { $0.id == person.id }) {
            person = freshPerson
        }
        lentCards = person.lentMe
        borrowedCards = person.borrowed
    }

    func updateCardQuantity(_ card: CardDTO, newQuantity: Int) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                card.quantity = newQuantity
                try await database.save(object: card, update: .modified)
                await self.loadLoanData()
            } catch is CancellationError {
                // Silently cancel
            } catch {
                self.toastQueue.enqueue(title: L10n.error, message: error.localizedDescription, type: .error, duration: 2.5)
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
                switch cardToDelete.type {
                case .lent:
                    self.person.lentMe.removeAll { $0.id == cardToDelete.card.id }
                case .borrow:
                    self.person.borrowed.removeAll { $0.id == cardToDelete.card.id }
                default:
                    break
                }

                try await database.save(object: self.person, update: .modified)
                await self.loadLoanData()
                self.cardToDelete = nil
                self.showingDeleteConfirmation = false
            } catch {
                self.toastQueue.enqueue(title: L10n.error, message: error.localizedDescription, type: .error, duration: 2.5)
            }
        }
    }

    func cancelDelete() {
        cardToDelete = nil
        showingDeleteConfirmation = false
    }

    var personFullName: String {
        PersonNameComponents(givenName: person.name, familyName: person.lastName)
            .formatted(.name(style: .long))
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
}
