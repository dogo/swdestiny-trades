//
//  CardDetailView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import SwiftUI

struct CardDetailView: View {
    @StateObject private var viewModel: CardDetailViewModel
    @Environment(\.dependencyContainer) private var container
    @State private var showingFullScreenImage = false
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showToast = false

    let cards: [CardDTO]
    let selectedCard: CardDTO

    init(cards: [CardDTO], selectedCard: CardDTO, viewModel: CardDetailViewModel? = nil) {
        self.cards = cards
        self.selectedCard = selectedCard
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: CardDetailViewModel(cards: cards, selectedCard: selectedCard))
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    ImageSlideshowWrapper(
                        imageInputs: viewModel.imageInputs,
                        currentIndex: viewModel.currentIndex,
                        onPageChanged: { index in
                            viewModel.updateCurrentIndex(index)
                        },
                        onImageTapped: {
                            showingFullScreenImage = true
                        }
                    )
                    .frame(height: 400)

                    cardInfoSection
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.shareCard()
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }

                    Button {
                        Task {
                            await viewModel.addToCollection()
                        }
                    } label: {
                        Image(asset: Asset.NavigationBar.icAddCollection)
                    }
                }
            }
            .sheet(isPresented: $showingFullScreenImage) {
                FullScreenImageViewer(
                    imageInputs: viewModel.imageInputs,
                    initialIndex: viewModel.currentIndex,
                    isPresented: $showingFullScreenImage
                )
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
        .onChange(of: viewModel.showToast) { newValue in
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
                StatView(title: "Cost", value: "\(viewModel.currentCard.cost)", color: .orange)
            }

            if viewModel.currentCard.health > 0 {
                StatView(title: "Health", value: "\(viewModel.currentCard.health)", color: .red)
            }

            if !viewModel.currentCard.points.isEmpty {
                StatView(title: "Points", value: viewModel.currentCard.points, color: .blue)
            }
        }
    }

    @ViewBuilder private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.cardInformation)
                .font(.headline)
                .foregroundColor(.primary)

            InfoRow(title: "Set", value: viewModel.currentCard.setName)
            InfoRow(title: "Type", value: viewModel.currentCard.typeName)
            InfoRow(title: "Faction", value: viewModel.currentCard.factionName)
            InfoRow(title: "Rarity", value: viewModel.currentCard.rarityName)

            if !viewModel.currentCard.affiliationName.isEmpty {
                InfoRow(title: "Affiliation", value: viewModel.currentCard.affiliationName)
            }

            if !viewModel.currentCard.illustrator.isEmpty {
                InfoRow(title: "Illustrator", value: viewModel.currentCard.illustrator)
            }

            InfoRow(title: "Deck Limit", value: "\(viewModel.currentCard.deckLimit)")

            if viewModel.currentCard.isUnique {
                InfoRow(title: "Unique", value: "Yes")
            }

            if viewModel.currentCard.hasDie {
                InfoRow(title: "Has Die", value: "Yes")
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
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

    return NavigationView {
        CardDetailView(cards: [sampleCard], selectedCard: sampleCard)
    }
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
