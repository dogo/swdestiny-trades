//
//  DeckGraphEmptyView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckGraphEmptyView: View {
    var body: some View {
        ContentUnavailableView {
            Label(L10n.noDataAvailable, systemImage: "chart.bar")
        } description: {
            Text(L10n.addCardsToYourDeckToSeeStatistics)
        }
    }
}
