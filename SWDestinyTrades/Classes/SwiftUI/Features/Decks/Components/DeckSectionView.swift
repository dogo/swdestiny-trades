//
//  DeckSectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckSectionView: View {
    let section: DeckSection
    let onCardTap: (CardDTO) -> Void
    let onQuantityChange: (CardDTO, Int) -> Void
    let onEliteToggle: (CardDTO, Bool) -> Void
    let onRemoveCard: (CardDTO) -> Void
    let onToggleCollapse: () -> Void

    var body: some View {
        Section {
            if !section.isCollapsed {
                ForEach(section.cards, id: \.id) { card in
                    DeckCardRowView(
                        card: card,
                        onTap: { onCardTap(card) },
                        onQuantityChange: { quantity in
                            onQuantityChange(card, quantity)
                        },
                        onEliteToggle: { isElite in
                            onEliteToggle(card, isElite)
                        },
                        onRemove: { onRemoveCard(card) }
                    )
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onRemoveCard(section.cards[index])
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        } header: {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggleCollapse()
                }
            } label: {
                HStack {
                    Text(section.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("(\(section.cardCount))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .rotationEffect(.degrees(section.isCollapsed ? 0 : 90))
                        .animation(.easeInOut(duration: 0.2), value: section.isCollapsed)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
