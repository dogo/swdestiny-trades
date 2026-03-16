//
//  CollectionCardRowView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionCardRowView: View {
    let card: CardDTO
    let onQuantityChange: (CardDTO, Int) -> Void
    let onTap: () -> Void
    let onRemove: (CardDTO) -> Void

    @State private var quantity: Int

    init(card: CardDTO, onQuantityChange: @escaping (CardDTO, Int) -> Void, onTap: @escaping () -> Void, onRemove: @escaping (CardDTO) -> Void) {
        self.card = card
        self.onQuantityChange = onQuantityChange
        self.onTap = onTap
        self.onRemove = onRemove
        _quantity = State(initialValue: card.quantity)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                CollectionCardIconView(card: card)
                CollectionCardInfoView(card: card)
                Spacer()
                CollectionQuantityView(card: card, quantity: $quantity, onChange: onQuantityChange)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .onChange(of: card.quantity) { _, newValue in
            quantity = newValue
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(L10n.delete, role: .destructive) {
                onRemove(card)
            }
        }
    }
}
