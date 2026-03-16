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
            Image("ic_\(card.typeCode)")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(card.factionColor())
                .frame(width: 25, height: 25)
                .accessibilityHidden(true)

            Text("\(quantity)")
                .font(.body)
                .frame(minWidth: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(1)

                if !card.subtitle.isEmpty {
                    Text(card.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
        .accessibilityAddTraits(.isButton)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(L10n.delete, role: .destructive) {
                onRemove()
            }
        }
    }
}
