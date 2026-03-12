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

                    CardInfoSection(card: viewModel.currentCard)
                }
            }

            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(L10n.share, systemImage: "square.and.arrow.up") {
                        showingShareSheet = true
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
                        .accessibilityLabel(L10n.addToCollection)
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
