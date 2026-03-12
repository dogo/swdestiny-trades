//
//  SearchEmptyResultsView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchEmptyResultsView: View {
    let query: String
    let onClear: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(L10n.noResultsFound)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(L10n.noCardsMatchViewmodelcurrentqueryTryA(query))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                onClear()
            } label: {
                Text(L10n.clearSearch)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
