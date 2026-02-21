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
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var dependencyContainer
    @Environment(\.dismiss) private var dismiss

    init(deck: DeckDTO?, dependencyContainer: DependencyContainer = .shared) {
        _viewModel = State(wrappedValue: DeckBuilderViewModel(deck: deck, dependencyContainer: dependencyContainer))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.isDeckEmpty {
                emptyDeckView
            } else {
                deckBuilderContent
            }
        }
        .navigationTitle(viewModel.deck.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                addCardButton
                deckGraphButton
                shareButton
            }
        }
        .sheet(isPresented: $viewModel.showingShareSheet) {
            ShareSheet(items: [viewModel.shareText])
        }
        .onAppear {
            viewModel.loadDeckData()
        }
    }

    // MARK: - View Components

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(L10n.loadingDeck)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyDeckView: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(L10n.emptyDeck)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.addCardsToStartBuildingYourDeck)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.addCards) {
                navigateToAddToDeck()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var deckBuilderContent: some View {
        VStack {
            deckStatsView
            deckSectionsList
        }
    }

    private var deckStatsView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(L10n.totalCardsViewmodeltotalcardcount(viewModel.totalCardCount))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(L10n.uniqueCardsViewmodeluniquecardcount(viewModel.uniqueCardCount))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }

    private var deckSectionsList: some View {
        List {
            ForEach(viewModel.deckSections, id: \.id) { section in
                DeckSectionView(
                    section: section,
                    onCardTap: { card in
                        navigateToCardDetail(card)
                    },
                    onQuantityChange: { card, quantity in
                        viewModel.updateCardQuantity(card, quantity: quantity)
                    },
                    onEliteToggle: { card, isElite in
                        viewModel.updateCharacterElite(card, isElite: isElite)
                    },
                    onRemoveCard: { card in
                        viewModel.removeCard(card)
                    },
                    onToggleCollapse: {
                        viewModel.toggleSection(section)
                    }
                )
            }
        }
        .listStyle(PlainListStyle())
    }

    private var addCardButton: some View {
        Button {
            navigateToAddToDeck()
        } label: {
            Image(systemName: "plus")
        }
    }

    private var deckGraphButton: some View {
        Button {
            navigateToDeckGraph()
        } label: {
            Image(systemName: "chart.bar")
        }
    }

    private var shareButton: some View {
        Button {
            viewModel.prepareShareText()
        } label: {
            Image(systemName: "square.and.arrow.up")
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
