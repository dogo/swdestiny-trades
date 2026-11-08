//
//  CollectionCardIconView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionCardIconView: View {
    let card: CardDTO

    var body: some View {
        CardImageView(
            imageUrl: card.imageUrl,
            width: 40,
            height: 56,
            cornerRadius: 4
        )
    }
}
