//
//  DeckBuilderView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckBuilderView: View {
    @State private var viewModel: DeckBuilderViewModel
    @State private var shareItem: ShareText?
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(deck: DeckDTO?, dependencyContainer: DependencyContainer = .shared) {
        _viewModel = State(wrappedValue: DeckBuilderViewModel(deck: deck, dependencyContainer: dependencyContainer))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                DeckBuilderLoadingView()
            } else if viewModel.isDeckEmpty {
                DeckBuilderEmptyView(onAddCards: navigateToAddToDeck)
            } else {
                VStack {
                    DeckStatsView(
                        totalCardCount: viewModel.totalCardCount,
                        uniqueCardCount: viewModel.uniqueCardCount
                    )
                    List {
                        ForEach(viewModel.deckSections, id: \.id) { section in
                            DeckSectionView(
                                section: section,
                                onCardTap: { navigateToCardDetail($0) },
                                onQuantityChange: { viewModel.updateCardQuantity($0, quantity: $1) },
                                onEliteToggle: { viewModel.updateCharacterElite($0, isElite: $1) },
                                onRemoveCard: { viewModel.removeCard($0) },
                                onToggleCollapse: { viewModel.toggleSection(section) }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle(viewModel.deck.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(L10n.addCards, systemImage: "plus", action: navigateToAddToDeck)
                Button(L10n.graph, systemImage: "chart.bar", action: navigateToDeckGraph)
                Button(L10n.share, systemImage: "square.and.arrow.up") {
                    viewModel.prepareShareText()
                }
            }
        }
        .onChange(of: viewModel.shareText) { _, newValue in
            shareItem = newValue.map { ShareText(value: $0) }
        }
        .sheet(item: $shareItem, onDismiss: { viewModel.shareText = nil }, content: { item in
            ShareSheet(items: [item.value])
        })
        .onAppear {
            Task {
                await viewModel.handleViewAppear()
            }
        }
    }

    // MARK: - Navigation Actions

    private func navigateToAddToDeck() {
        navigationCoordinator.navigate(to: .addToDeck(viewModel.deck))
    }

    private func navigateToDeckGraph() {
        navigationCoordinator.navigate(to: .deckGraph(viewModel.deck))
    }

    private func navigateToCardDetail(_ card: CardDTO) {
        let allCards = viewModel.deckSections.flatMap(\.cards)
        navigationCoordinator.navigate(to: .cardDetail(allCards, card, false))
    }
}

#Preview {
    let sampleDeck = DeckDTO()
    sampleDeck.name = "Sample Deck"

    return NavigationStack {
        DeckBuilderView(deck: sampleDeck)
            .environment(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}

#Preview("Empty Deck") {
    return NavigationStack {
        DeckBuilderView(deck: nil)
            .environment(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}
