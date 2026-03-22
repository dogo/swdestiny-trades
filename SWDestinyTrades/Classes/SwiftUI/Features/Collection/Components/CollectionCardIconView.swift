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
        AsyncImage(url: URL(string: card.imageUrl)) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(asset: Asset.icCardback)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.5)
            case .empty:
                ZStack {
                    Image(asset: Asset.icCardback)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.3)

                    ProgressView()
                        .scaleEffect(0.8)
                }
            @unknown default:
                Image(asset: Asset.icCardback)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.5)
            }
        }
        .frame(width: 40, height: 56)
        .clipShape(.rect(cornerRadius: 4))
    }
}
