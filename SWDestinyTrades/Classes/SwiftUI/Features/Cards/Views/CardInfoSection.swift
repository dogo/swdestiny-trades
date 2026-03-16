//
//  CardInfoSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardInfoSection: View {
    let card: CardDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            cardNameSection
            CardStatsSection(card: card)
            cardTextSection
            cardFlavorSection
            CardAdditionalInfoSection(card: card)
        }
        .padding()
        .background(Color(.systemBackground))
    }

    private var cardNameSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            if !card.subtitle.isEmpty {
                Text(card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder private var cardTextSection: some View {
        if !card.text.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.cardText)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(card.text)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    @ViewBuilder private var cardFlavorSection: some View {
        if !card.flavor.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.flavorText)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(card.flavor)
                    .font(.body)
                    .italic()
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
