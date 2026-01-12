//
//  LoanDetailView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LoanDetailView: View {

    @StateObject private var viewModel: LoanDetailViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @State private var showToast = false

    init(personId: String) {
        _viewModel = StateObject(wrappedValue: LoanDetailViewModel(personId: personId))
    }

    init(person: PersonDTO) {
        _viewModel = StateObject(wrappedValue: LoanDetailViewModel(person: person))
    }

    var body: some View {
        List {
            Section {
                if viewModel.lentCards.isEmpty {
                    EmptyLoanRowView(
                        message: "No cards lent",
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
                                navigationCoordinator.navigate(to: .cardDetail([card], card))
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

            Section {
                if viewModel.borrowedCards.isEmpty {
                    EmptyLoanRowView(
                        message: "No cards borrowed",
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
                                navigationCoordinator.navigate(to: .cardDetail([card], card))
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
        .navigationTitle(viewModel.personFullName)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            viewModel.loadLoanData()
        }
        .confirmationDialog("Delete Card", isPresented: $viewModel.showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelDelete()
            }
        } message: {
            if let cardToDelete = viewModel.cardToDelete {
                Text(L10n.areYouSureYouWantToRemove(cardToDelete.card.name))
            }
        }
        .overlay(alignment: .top) {
            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { newValue in
            showToast = newValue
        }
        .onAppear {
            viewModel.loadLoanData()
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
        HStack {
            Image("ic_\(card.typeCode)")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(card.factionColor())

            Text(L10n.quantity(quantity))
                .font(.system(size: 18, weight: .medium))
                .frame(minWidth: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(card.setName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Stepper("", value: $quantity, in: 1 ... 99)
                .labelsHidden()
                .onChange(of: quantity) { newValue in
                    onQuantityChanged(newValue)
                }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
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
                .foregroundColor(.secondary)

            Button(actionText) {
                action()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
