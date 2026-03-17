//
//  DeckCardRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

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
            CardInfoButton(card: card, quantity: quantity, onTap: onTap)
            DeckQuantityControl(card: card, quantity: $quantity, isElite: $isElite, onQuantityChange: onQuantityChange, onEliteToggle: onEliteToggle)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(L10n.delete, role: .destructive, action: onRemove)
        }
    }
}
