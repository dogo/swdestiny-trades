//
//  AddToDeckView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddToDeckView: View {
    @State private var viewModel: AddToDeckViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(deck: DeckDTO, viewModel: AddToDeckViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? AddToDeckViewModel(deck: deck))
    }

    var body: some View {
        VStack(spacing: 0) {
            dataSourceSelector

            if viewModel.isLoading {
                LoadingView()
            } else {
                cardsList
            }
        }
        .navigationTitle(L10n.addCard)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .onSubmit(of: .search) {}
        .toastQueue(viewModel.toastQueue)
        .task {
            viewModel.loadRemoteCards()
        }
    }

    private var dataSourceSelector: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.loadRemoteCards()
            } label: {
                Text(L10n.remote)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.dataSource == .remote ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.dataSource == .remote ? Color.blue : Color.clear)
            }

            Button {
                viewModel.loadLocalCards()
            } label: {
                Text(L10n.local)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.dataSource == .local ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.dataSource == .local ? Color.blue : Color.clear)
            }
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 8))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    @ViewBuilder private var cardsList: some View {
        if viewModel.filteredItems.isEmpty {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ?
                    (viewModel.dataSource == .remote ? L10n.pullToRefreshToLoadCards : L10n.noCardsInCollection) :
                    L10n.noCardsMatchSearch,
                systemImage: "rectangle.stack"
            )
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                AddCardDetailRowView(card: card) {
                    viewModel.addCardToDeck(card)
                } onDetailTap: {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card, false))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
            .refreshable {
                if viewModel.dataSource == .remote {
                    viewModel.loadRemoteCards()
                } else {
                    viewModel.loadLocalCards()
                }
            }
        }
    }
}
