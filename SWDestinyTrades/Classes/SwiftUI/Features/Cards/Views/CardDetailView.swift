//
//  CardDetailView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardDetailView: View {
    @State private var viewModel: CardDetailViewModel
    @Environment(\.dependencyContainer) private var container
    @State private var showingFullScreenImage = false
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showToast = false

    let cards: [CardDTO]
    let selectedCard: CardDTO
    let showAddToCollection: Bool

    init(cards: [CardDTO], selectedCard: CardDTO, showAddToCollection: Bool = true, viewModel: CardDetailViewModel? = nil) {
        self.cards = cards
        self.selectedCard = selectedCard
        self.showAddToCollection = showAddToCollection
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: CardDetailViewModel(cards: cards, selectedCard: selectedCard))
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    CarouselView(
                        items: viewModel.imageSources,
                        imageLoader: container.resolve(type: ImageLoadingService.self),
                        currentPage: $viewModel.currentIndex,
                        currentImage: $shareImage,
                        placeholder: Asset.icCardback.image,
                        showsPageIndicator: false,
                        onItemTapped: { _ in showingFullScreenImage = true }
                    )
                    .frame(height: 400)

                    cardInfoSection
                }
            }

            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(shareImage == nil)

                    if showAddToCollection {
                        Button {
                            Task {
                                await viewModel.addToCollection()
                            }
                        } label: {
                            Image(asset: Asset.NavigationBar.icAddCollection)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingFullScreenImage) {
                if viewModel.currentIndex < viewModel.imageSources.count {
                    FullScreenCarouselViewer(
                        source: viewModel.imageSources[viewModel.currentIndex],
                        imageLoader: container.resolve(type: ImageLoadingService.self),
                        isPresented: $showingFullScreenImage
                    )
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let shareImage {
                    ShareSheet(items: [shareImage])
                }
            }

            VStack {
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
                Spacer()
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { _, newValue in
            showToast = newValue
        }
    }

    @ViewBuilder private var cardInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentCard.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                if !viewModel.currentCard.subtitle.isEmpty {
                    Text(viewModel.currentCard.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            cardStatsSection

            if !viewModel.currentCard.text.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.cardText)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(viewModel.currentCard.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if !viewModel.currentCard.flavor.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.flavorText)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(viewModel.currentCard.flavor)
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            additionalInfoSection
        }
        .padding()
        .background(Color(.systemBackground))
    }

    @ViewBuilder private var cardStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            if viewModel.currentCard.cost > 0 {
                StatView(title: L10n.cost, value: "\(viewModel.currentCard.cost)", color: .orange)
            }

            if viewModel.currentCard.health > 0 {
                StatView(title: L10n.health, value: "\(viewModel.currentCard.health)", color: .red)
            }

            if !viewModel.currentCard.points.isEmpty {
                StatView(title: L10n.points, value: viewModel.currentCard.points, color: .blue)
            }
        }
    }

    @ViewBuilder private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.cardInformation)
                .font(.headline)
                .foregroundColor(.primary)

            InfoRow(title: L10n.set, value: viewModel.currentCard.setName)
            InfoRow(title: L10n.type, value: viewModel.currentCard.typeName)
            InfoRow(title: L10n.faction, value: viewModel.currentCard.factionName)
            InfoRow(title: L10n.rarity, value: viewModel.currentCard.rarityName)

            if !viewModel.currentCard.affiliationName.isEmpty {
                InfoRow(title: L10n.affiliation, value: viewModel.currentCard.affiliationName)
            }

            if !viewModel.currentCard.illustrator.isEmpty {
                InfoRow(title: L10n.illustrator, value: viewModel.currentCard.illustrator)
            }

            InfoRow(title: L10n.deckLimit, value: "\(viewModel.currentCard.deckLimit)")

            if viewModel.currentCard.isUnique {
                InfoRow(title: L10n.unique, value: L10n.yes)
            }

            if viewModel.currentCard.hasDie {
                InfoRow(title: L10n.hasDie, value: L10n.yes)
            }
        }
    }
}

#Preview {
    let sampleCard = CardDTO()
    sampleCard.name = "Luke Skywalker"
    sampleCard.subtitle = "Jedi Knight"
    sampleCard.cost = 12
    sampleCard.health = 11
    sampleCard.points = "12/15"
    sampleCard.text = "Action - Exhaust this support to reroll a die."
    sampleCard.flavor = "That's no moon. It's a space station."
    sampleCard.setName = "Awakenings"
    sampleCard.typeName = "Character"
    sampleCard.factionName = "Hero"
    sampleCard.rarityName = "Rare"
    sampleCard.illustrator = "Artist Name"
    sampleCard.deckLimit = 1
    sampleCard.isUnique = true
    sampleCard.hasDie = true

    return NavigationStack {
        CardDetailView(cards: [sampleCard], selectedCard: sampleCard)
    }
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
