//
//  CardRowImageView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardRowImageView: View {
    let card: CardDTO

    var body: some View {
        CardImageView(
            imageUrl: card.imageUrl,
            width: 60,
            height: 84,
            cornerRadius: 8,
            showsBorder: true
        )
    }
}
