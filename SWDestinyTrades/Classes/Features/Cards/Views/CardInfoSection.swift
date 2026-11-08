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
            CardNameSection(name: card.name, subtitle: card.subtitle)
            CardStatsSection(card: card)
            CardTextSection(text: card.text)
            CardFlavorSection(flavor: card.flavor)
            CardAdditionalInfoSection(card: card)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
