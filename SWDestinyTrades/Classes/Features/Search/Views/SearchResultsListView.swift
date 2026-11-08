//
//  SearchResultsListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchResultsListView: View {
    let results: [CardDTO]
    let query: String
    let onClear: () -> Void
    let onCardSelected: (CardDTO) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(L10n.viewmodelsearchresultscountResultsFor(results.count, query))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    onClear()
                } label: {
                    Text(L10n.clear)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            List(results, id: \.code) { card in
                SearchResultRowView(card: card) {
                    onCardSelected(card)
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }
}
