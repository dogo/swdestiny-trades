//
//  CardAdditionalInfoSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardAdditionalInfoSection: View {
    let card: CardDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.cardInformation)
                .font(.headline)
                .foregroundStyle(.primary)

            InfoRow(title: L10n.set, value: card.setName)
            InfoRow(title: L10n.type, value: card.typeName)
            InfoRow(title: L10n.faction, value: card.factionName)
            InfoRow(title: L10n.rarity, value: card.rarityName)

            if !card.affiliationName.isEmpty {
                InfoRow(title: L10n.affiliation, value: card.affiliationName)
            }

            if !card.illustrator.isEmpty {
                InfoRow(title: L10n.illustrator, value: card.illustrator)
            }

            InfoRow(title: L10n.deckLimit, value: "\(card.deckLimit)")

            if card.isUnique {
                InfoRow(title: L10n.unique, value: L10n.yes)
            }

            if card.hasDie {
                InfoRow(title: L10n.hasDie, value: L10n.yes)
            }
        }
    }
}
