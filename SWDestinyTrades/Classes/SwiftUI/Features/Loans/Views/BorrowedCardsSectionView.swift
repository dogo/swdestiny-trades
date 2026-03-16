//
//  BorrowedCardsSectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct BorrowedCardsSectionView: View {
    let cards: [CardDTO]
    let onQuantityChanged: (CardDTO, Int) -> Void
    let onCardTap: (CardDTO) -> Void
    let onDelete: (CardDTO) -> Void
    let onAddCard: () -> Void

    var body: some View {
        Section {
            if cards.isEmpty {
                EmptyLoanRowView(
                    message: L10n.noBorrowedCards,
                    actionText: L10n.addMyCard,
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

                AddCardRowView(text: L10n.addMyCard, action: onAddCard)
            }
        } header: {
            Text(L10n.hasBorrowedMy)
        }
    }
}
