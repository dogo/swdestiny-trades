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
            AddToDeckDataSourceSelector(
                dataSource: viewModel.dataSource,
                onSelectRemote: viewModel.loadRemoteCards,
                onSelectLocal: viewModel.loadLocalCards
            )

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

    @ViewBuilder private var cardsList: some View {
        if viewModel.filteredItems.isEmpty {
            if !viewModel.searchText.isEmpty {
                ContentUnavailableView.search
            } else if viewModel.dataSource == .remote {
                ContentUnavailableView(L10n.noCardsFound,
                                       systemImage: "rectangle.stack",
                                       description: Text(L10n.pullToRefreshToLoadCards))
            } else {
                ContentUnavailableView(L10n.noCardsFound,
                                       systemImage: "rectangle.stack",
                                       description: Text(L10n.noCardsInCollection))
            }
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
                await viewModel.awaitCurrentLoad()
            }
        }
    }
}
