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
        AsyncImage(url: URL(string: card.imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ZStack {
                Image(asset: Asset.icCardback)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)

                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .frame(width: 40, height: 56)
        .clipShape(.rect(cornerRadius: 4))
    }
}
