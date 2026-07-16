//
//  DeckListContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckListContent: View {
    let items: [DeckListItem]
    let onEdit: (DeckListItem) -> Void
    let onGraph: (DeckListItem) -> Void
    let onDelete: (DeckListItem) -> Void
    let onRename: (DeckListItem, String) -> Void

    var body: some View {
        List {
            ForEach(items) { item in
                DeckRowView(item: item) {
                    onEdit(item)
                } onGraph: {
                    onGraph(item)
                } onDelete: {
                    onDelete(item)
                } onRename: { newName in
                    onRename(item, newName)
                }
            }
        }
        .listStyle(.plain)
    }
}
