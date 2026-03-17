//
//  LoanDetailView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LoanDetailView: View {
    @State private var viewModel: LoanDetailViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(personId: String) {
        _viewModel = State(wrappedValue: LoanDetailViewModel(personId: personId))
    }

    init(person: PersonDTO) {
        _viewModel = State(wrappedValue: LoanDetailViewModel(person: person))
    }

    var body: some View {
        List {
            LentCardsSectionView(
                cards: viewModel.lentCards,
                onQuantityChanged: { card, quantity in viewModel.updateCardQuantity(card, newQuantity: quantity) },
                onCardTap: { card in navigationCoordinator.navigate(to: .cardDetail([card], card, false)) },
                onDelete: { card in viewModel.prepareToDelete(card, type: .lent) },
                onAddCard: { navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .lent)) }
            )
            BorrowedCardsSectionView(
                cards: viewModel.borrowedCards,
                onQuantityChanged: { card, quantity in viewModel.updateCardQuantity(card, newQuantity: quantity) },
                onCardTap: { card in navigationCoordinator.navigate(to: .cardDetail([card], card, false)) },
                onDelete: { card in viewModel.prepareToDelete(card, type: .borrow) },
                onAddCard: { navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .borrow)) }
            )
        }
        .navigationTitle(viewModel.personFullName)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadLoanData()
        }
        .confirmationDialog(L10n.deleteCard, isPresented: $viewModel.showingDeleteConfirmation) {
            Button(L10n.delete, role: .destructive) {
                viewModel.confirmDelete()
            }
            Button(L10n.cancel, role: .cancel) {
                viewModel.cancelDelete()
            }
        } message: {
            if let cardToDelete = viewModel.cardToDelete {
                Text(L10n.areYouSureYouWantToRemove(cardToDelete.card.name))
            }
        }
        .toastQueue(viewModel.toastQueue)
        .onAppear {
            Task {
                await viewModel.loadLoanData()
            }
        }
    }
}
