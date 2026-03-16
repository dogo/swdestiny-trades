//
//  DeckNameSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckNameSection: View {
    let deck: DeckDTO
    let cardCount: Int
    @Binding var isEditing: Bool
    @Binding var editedName: String
    let onEdit: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isEditing {
                TextField(L10n.deckName, text: $editedName)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit(onSave)
            } else {
                Button(action: onEdit) {
                    Text(deck.name.isEmpty ? L10n.unnamedDeck : deck.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }

            Text(L10n.cardsCount(cardCount))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
