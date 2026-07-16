//
//  DeckRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckRowView: View {
    let item: DeckListItem
    let onEdit: () -> Void
    let onGraph: () -> Void
    let onDelete: () -> Void
    let onRename: (String) -> Void

    @State private var isEditing = false
    @State private var editedName = ""

    var body: some View {
        HStack {
            DeckNameSection(
                name: item.name,
                cardCount: item.cardCount,
                isEditing: $isEditing,
                editedName: $editedName,
                onEdit: onEdit,
                onSave: saveName
            )
            DeckActionButton(
                isEditing: isEditing,
                onSave: saveName,
                onStartEditing: startEditing
            )
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(L10n.delete, systemImage: "trash", role: .destructive) {
                onDelete()
            }
            .tint(ColorPalette.red)

            Button(L10n.graph, systemImage: "chart.bar") {
                onGraph()
            }
            .tint(ColorPalette.blue)
        }
    }

    // MARK: - Private Methods

    private func startEditing() {
        editedName = item.name
        isEditing = true
    }

    private func saveName() {
        let trimmedName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty, trimmedName != item.name {
            onRename(trimmedName)
        }
        isEditing = false
    }
}
