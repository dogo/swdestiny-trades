//
//  DeckListContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckListContent: View {
    let decks: [DeckDTO]
    let cardCounts: [String: Int]
    let onEdit: (DeckDTO) -> Void
    let onGraph: (DeckDTO) -> Void
    let onDelete: (DeckDTO) -> Void
    let onRename: (DeckDTO, String) -> Void

    var body: some View {
        List {
            ForEach(decks, id: \.id) { deck in
                DeckRowView(deck: deck, cardCount: cardCounts[deck.id] ?? 0) {
                    onEdit(deck)
                } onGraph: {
                    onGraph(deck)
                } onDelete: {
                    onDelete(deck)
                } onRename: { newName in
                    onRename(deck, newName)
                }
            }
        }
        .listStyle(.plain)
    }
}
