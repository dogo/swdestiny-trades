//
//  SearchInitialStateView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchInitialStateView: View {
    let popularSearches: [String]
    let onSearch: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(L10n.searchCards)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(L10n.enterACardNameTypeOrAnyKeywordToSearch)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 12) {
                Text(L10n.popularSearches)
                    .font(.headline)
                    .foregroundStyle(.primary)

                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100), spacing: 8)
                ], spacing: 8) {
                    ForEach(popularSearches, id: \.self) { search in
                        Button {
                            onSearch(search)
                        } label: {
                            Text(search)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
