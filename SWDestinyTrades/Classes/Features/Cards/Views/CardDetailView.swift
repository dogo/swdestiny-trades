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
        CardDetailScrollContent(viewModel: viewModel, showAddToCollection: showAddToCollection)
            .toastQueue(viewModel.toastQueue)
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
