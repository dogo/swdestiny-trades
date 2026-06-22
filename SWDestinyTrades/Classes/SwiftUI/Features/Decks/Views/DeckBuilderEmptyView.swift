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
        ContentUnavailableView {
            Label(L10n.emptyDeck, systemImage: "rectangle.stack.badge.plus")
        } description: {
            Text(L10n.addCardsToStartBuildingYourDeck)
        } actions: {
            Button(L10n.addCards, action: onAddCards)
                .buttonStyle(.borderedProminent)
                .tint(ColorPalette.appTheme)
                .foregroundStyle(ColorPalette.appThemeForeground)
        }
    }
}
