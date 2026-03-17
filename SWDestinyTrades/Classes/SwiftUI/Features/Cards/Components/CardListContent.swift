//
//  CardListContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardListContent: View {
    let filteredItems: [CardDTO]
    let isLoading: Bool
    let searchText: String
    let onCardSelected: (CardDTO) -> Void

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
                CardRowView(card: card) {
                    onCardSelected(card)
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }
}
