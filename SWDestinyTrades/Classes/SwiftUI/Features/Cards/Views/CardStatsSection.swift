//
//  CardStatsSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardStatsSection: View {
    let card: CardDTO

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            if card.cost > 0 {
                StatView(title: L10n.cost, value: "\(card.cost)", color: .orange)
            }

            if card.health > 0 {
                StatView(title: L10n.health, value: "\(card.health)", color: .red)
            }

            if !card.points.isEmpty {
                StatView(title: L10n.points, value: card.points, color: .blue)
            }
        }
    }
}
