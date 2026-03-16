//
//  CollectionContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionContent: View {
    let viewModel: UserCollectionViewModel

    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
                EmptyStateView(
                    title: L10n.noCardsFound,
                    message: viewModel.searchText.isEmpty ? L10n.collectionEmpty : L10n.noCardsMatchSearch,
                    systemImage: "rectangle.stack"
                )
            } else {
                List(viewModel.filteredItems, id: \.code) { card in
                    CollectionCardRowView(card: card) { updatedCard, quantity in
                        Task {
                            await viewModel.updateCardQuantity(updatedCard, quantity: quantity)
                        }
                    } onTap: {
                        navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                    } onRemove: { card in
                        viewModel.removeCard(card)
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.loadCollection()
            }
            if viewModel.availableSets.isEmpty {
                viewModel.loadAvailableSets()
            }
        }
    }
}
