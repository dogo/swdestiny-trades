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
    @State private var fullScreenSource: ImageSource?
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    let cards: [CardDTO]
    let selectedCard: CardDTO
    let showAddToCollection: Bool

    init(cards: [CardDTO], selectedCard: CardDTO, showAddToCollection: Bool = true, viewModel: CardDetailViewModel? = nil) {
        self.cards = cards
        self.selectedCard = selectedCard
        self.showAddToCollection = showAddToCollection
        _viewModel = State(wrappedValue: viewModel ?? CardDetailViewModel(cards: cards, selectedCard: selectedCard))
    }

    var body: some View {
        scrollContent
            .toastQueue(viewModel.toastQueue)
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                CarouselView(
                    items: viewModel.imageSources,
                    imageLoader: viewModel.imageLoader,
                    currentPage: $viewModel.currentIndex,
                    currentImage: $shareImage,
                    placeholder: Asset.icCardback.image,
                    showsPageIndicator: false
                ) { index in
                    guard index < viewModel.imageSources.count else { return }
                    fullScreenSource = viewModel.imageSources[index]
                }
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
        .sheet(item: $fullScreenSource) { source in
            FullScreenCarouselViewer(
                source: source,
                imageLoader: viewModel.imageLoader
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareImage {
                ShareSheet(items: [shareImage])
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
}
