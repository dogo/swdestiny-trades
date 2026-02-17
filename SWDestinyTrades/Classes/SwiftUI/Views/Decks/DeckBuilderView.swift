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
        navigationCoordinator.navigate(to: .cardDetail(allCards, card))
    }
}

// MARK: - Deck Section View

struct DeckSectionView: View {
    let section: DeckSection
    let onCardTap: (CardDTO) -> Void
    let onQuantityChange: (CardDTO, Int) -> Void
    let onEliteToggle: (CardDTO, Bool) -> Void
    let onRemoveCard: (CardDTO) -> Void
    let onToggleCollapse: () -> Void

    var body: some View {
        Section {
            if !section.isCollapsed {
                ForEach(section.cards, id: \.id) { card in
                    DeckCardRowView(
                        card: card,
                        onTap: { onCardTap(card) },
                        onQuantityChange: { quantity in
                            onQuantityChange(card, quantity)
                        },
                        onEliteToggle: { isElite in
                            onEliteToggle(card, isElite)
                        },
                        onRemove: { onRemoveCard(card) }
                    )
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onRemoveCard(section.cards[index])
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        } header: {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggleCollapse()
                }
            } label: {
                HStack {
                    Text(section.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(L10n.sectioncardcount(section.cardCount))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: section.isCollapsed ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .rotationEffect(.degrees(section.isCollapsed ? 0 : 0))
                        .animation(.easeInOut(duration: 0.3), value: section.isCollapsed)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Deck Card Row View

struct DeckCardRowView: View {
    let card: CardDTO
    let onTap: () -> Void
    let onQuantityChange: (Int) -> Void
    let onEliteToggle: (Bool) -> Void
    let onRemove: () -> Void

    @State private var quantity: Int
    @State private var isElite: Bool

    init(card: CardDTO, onTap: @escaping () -> Void, onQuantityChange: @escaping (Int) -> Void, onEliteToggle: @escaping (Bool) -> Void, onRemove: @escaping () -> Void) {
        self.card = card
        self.onTap = onTap
        self.onQuantityChange = onQuantityChange
        self.onEliteToggle = onEliteToggle
        self.onRemove = onRemove
        _quantity = State(initialValue: card.quantity)
        _isElite = State(initialValue: card.isElite)
    }

    var body: some View {
        HStack {
            Image("ic_\(card.typeCode)")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(card.factionColor())
                .frame(width: 25, height: 25)

            Text(L10n.quantity(quantity))
                .font(.system(size: 18, weight: .medium))
                .frame(minWidth: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(1)

                if !card.subtitle.isEmpty {
                    Text(card.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if card.typeCode == "character", card.isUnique {
                EliteToggleButton(isElite: $isElite) { newValue in
                    onEliteToggle(newValue)
                }
            } else if !(card.typeCode == "character" && card.isUnique), card.typeCode != "battlefield" {
                Stepper("", value: $quantity, in: 1 ... card.deckLimit) { _ in
                    onQuantityChange(quantity)
                }
                .labelsHidden()
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete", role: .destructive) {
                onRemove()
            }
        }
    }
}

// MARK: - Elite Toggle Button

struct EliteToggleButton: View {
    @Binding var isElite: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        Button {
            isElite.toggle()
            onToggle(isElite)
        } label: {
            Text(isElite ? L10n.elite : L10n.nonElite)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isElite ? Color.primary : Color.clear)
                )
                .foregroundColor(isElite ? Color(.systemBackground) : Color.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
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
