//
//  AddCardListContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddCardListContent: View {
    let filteredItems: [CardDTO]
    let isLoading: Bool
    let searchText: String
    let onAddCard: (CardDTO) -> Void
    let onDetailTap: (CardDTO) -> Void

    var body: some View {
        if filteredItems.isEmpty, !isLoading {
            if searchText.isEmpty {
                ContentUnavailableView(L10n.noCardsFound,
                                       systemImage: "rectangle.stack",
                                       description: Text(L10n.pullToRefreshToLoadCards))
            } else {
                ContentUnavailableView.search
            }
        } else {
            List(filteredItems, id: \.code) { card in
                AddCardDetailRowView(card: card) {
                    onAddCard(card)
                } onDetailTap: {
                    onDetailTap(card)
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }
}
