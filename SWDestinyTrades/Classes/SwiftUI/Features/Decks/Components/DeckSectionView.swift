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
                        .foregroundColor(.primary)

                    Text("(\(section.cardCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: section.isCollapsed ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .rotationEffect(.degrees(section.isCollapsed ? 0 : 0))
                        .animation(.easeInOut(duration: 0.3), value: section.isCollapsed)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
