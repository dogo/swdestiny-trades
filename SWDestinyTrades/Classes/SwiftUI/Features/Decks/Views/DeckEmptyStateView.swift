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
        VStack(spacing: 20) {
            Image(systemName: "rectangle.stack")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(L10n.noDecksYet)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.createYourFirstDeckToGetStarted)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.createNewDeck, action: onCreateDeck)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
