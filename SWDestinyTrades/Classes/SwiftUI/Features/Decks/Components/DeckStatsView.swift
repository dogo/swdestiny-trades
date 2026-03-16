//
//  DeckStatsView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckStatsView: View {
    let totalCardCount: Int
    let uniqueCardCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(L10n.totalCardsViewmodeltotalcardcount(totalCardCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(L10n.uniqueCardsViewmodeluniquecardcount(uniqueCardCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
}
