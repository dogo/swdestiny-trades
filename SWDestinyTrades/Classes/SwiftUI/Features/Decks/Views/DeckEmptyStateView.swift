//
//  DeckEmptyStateView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckEmptyStateView: View {
    let onCreateDeck: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(L10n.noDecksYet, systemImage: "rectangle.stack")
        } description: {
            Text(L10n.createYourFirstDeckToGetStarted)
        } actions: {
            Button(L10n.createNewDeck, action: onCreateDeck)
                .buttonStyle(.borderedProminent)
        }
    }
}
