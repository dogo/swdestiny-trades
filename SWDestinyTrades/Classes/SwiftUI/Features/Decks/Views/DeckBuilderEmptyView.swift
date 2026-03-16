//
//  DeckBuilderEmptyView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckBuilderEmptyView: View {
    let onAddCards: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(L10n.emptyDeck)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.addCardsToStartBuildingYourDeck)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.addCards, action: onAddCards)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
