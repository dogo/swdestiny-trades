//
//  DeckNameSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckNameSection: View {
    let name: String
    let cardCount: Int
    @Binding var isEditing: Bool
    @Binding var editedName: String
    let onEdit: () -> Void
    let onSave: () -> Void

    var body: some View {
        if isEditing {
            VStack(alignment: .leading, spacing: 4) {
                TextField(L10n.deckName, text: $editedName)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit(onSave)

                cardCountLabel
            }
        } else {
            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name.isEmpty ? L10n.unnamedDeck : name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    cardCountLabel
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    private var cardCountLabel: some View {
        Text(L10n.cardsCount(cardCount))
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
