//
//  DeckRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckRowView: View {
    let deck: DeckDTO
    let cardCount: Int
    let onEdit: () -> Void
    let onGraph: () -> Void
    let onDelete: () -> Void
    let onRename: (String) -> Void

    @State private var isEditing = false
    @State private var editedName = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if isEditing {
                    TextField("Deck Name", text: $editedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            saveName()
                        }
                } else {
                    Button(action: onEdit) {
                        Text(deck.name.isEmpty ? "Unnamed Deck" : deck.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                }

                Text(L10n.cardsCount(cardCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isEditing {
                Button(L10n.done) {
                    saveName()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            } else {
                Button(L10n.edit, systemImage: "pencil", action: startEditing)
                    .foregroundStyle(.blue)
                    .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(L10n.delete, role: .destructive) {
                onDelete()
            }
            Button(L10n.graph) {
                onGraph()
            }
            .tint(.blue)
        }
    }

    // MARK: - Private Methods

    private func startEditing() {
        editedName = deck.name
        isEditing = true
    }

    private func saveName() {
        let trimmedName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty, trimmedName != deck.name {
            onRename(trimmedName)
        }
        isEditing = false
    }
}
