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
            lentSection
            borrowedSection
        }
        .navigationTitle(viewModel.personFullName)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            viewModel.loadLoanData()
        }
        .confirmationDialog("Delete Card", isPresented: $viewModel.showingDeleteConfirmation) {
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
            viewModel.loadLoanData()
        }
    }

    private var lentSection: some View {
        Section {
            if viewModel.lentCards.isEmpty {
                EmptyLoanRowView(
                    message: L10n.noLentCards,
                    actionText: L10n.addCard
                ) {
                    navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .lent))
                }
            } else {
                ForEach(viewModel.lentCards, id: \.id) { card in
                    LoanCardRowView(
                        card: card,
                        onQuantityChanged: { newQuantity in
                            viewModel.updateCardQuantity(card, newQuantity: newQuantity)
                        },
                        onTap: {
                            navigationCoordinator.navigate(to: .cardDetail([card], card, false))
                        }
                    )
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let card = viewModel.lentCards[index]
                        viewModel.prepareToDelete(card, type: .lent)
                    }
                }

                AddCardRowView(text: L10n.addCard.appending("...")) {
                    navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .lent))
                }
            }
        } header: {
            Text(L10n.hasLentMe)
        }
    }

    private var borrowedSection: some View {
        Section {
            if viewModel.borrowedCards.isEmpty {
                EmptyLoanRowView(
                    message: L10n.noBorrowedCards,
                    actionText: L10n.addMyCard
                ) {
                    navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .borrow))
                }
            } else {
                ForEach(viewModel.borrowedCards, id: \.id) { card in
                    LoanCardRowView(
                        card: card,
                        onQuantityChanged: { newQuantity in
                            viewModel.updateCardQuantity(card, newQuantity: newQuantity)
                        },
                        onTap: {
                            navigationCoordinator.navigate(to: .cardDetail([card], card, false))
                        }
                    )
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let card = viewModel.borrowedCards[index]
                        viewModel.prepareToDelete(card, type: .borrow)
                    }
                }

                AddCardRowView(text: L10n.addMyCard) {
                    navigationCoordinator.navigate(to: .addCardToPerson(viewModel.person.id, .borrow))
                }
            }
        } header: {
            Text(L10n.hasBorrowedMy)
        }
    }
}

struct LoanCardRowView: View {
    let card: CardDTO
    let onQuantityChanged: (Int) -> Void
    let onTap: () -> Void

    @State private var quantity: Int

    init(card: CardDTO, onQuantityChanged: @escaping (Int) -> Void, onTap: @escaping () -> Void) {
        self.card = card
        self.onQuantityChanged = onQuantityChanged
        self.onTap = onTap
        _quantity = State(initialValue: card.quantity)
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image("ic_\(card.typeCode)")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(card.factionColor())

                Text("\(quantity)")
                    .font(.body)
                    .frame(minWidth: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(card.name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(card.setName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Stepper("", value: $quantity, in: 1 ... 99)
                    .labelsHidden()
                    .onChange(of: quantity) { _, newValue in
                        onQuantityChanged(newValue)
                    }

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            quantity = card.quantity
        }
    }
}

struct EmptyLoanRowView: View {
    let message: String
    let actionText: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button(actionText) {
                action()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
