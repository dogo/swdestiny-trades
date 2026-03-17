//
//  LentCardsSectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LentCardsSectionView: View {
    let cards: [CardDTO]
    let onQuantityChanged: (CardDTO, Int) -> Void
    let onCardTap: (CardDTO) -> Void
    let onDelete: (CardDTO) -> Void
    let onAddCard: () -> Void

    var body: some View {
        Section {
            if cards.isEmpty {
                EmptyLoanRowView(
                    message: L10n.noLentCards,
                    actionText: L10n.addCard,
                    action: onAddCard
                )
            } else {
                ForEach(cards, id: \.id) { card in
                    LoanCardRowView(
                        card: card,
                        onQuantityChanged: { onQuantityChanged(card, $0) },
                        onTap: { onCardTap(card) }
                    )
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onDelete(cards[index])
                    }
                }

                AddCardRowView(text: L10n.addCard + "...", action: onAddCard)
            }
        } header: {
            Text(L10n.hasLentMe)
        }
    }
}
