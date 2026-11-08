//
//  CardInfoButton.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardInfoButton: View {
    let card: CardDTO
    let quantity: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text.swdIcon(card.typeIcon, size: 25)
                    .foregroundStyle(card.factionColor())
                    .frame(width: 25, height: 25)
                    .accessibilityHidden(true)

                Text("\(quantity)")
                    .font(.body)
                    .frame(minWidth: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(card.name)
                        .font(.headline)
                        .lineLimit(1)

                    if !card.subtitle.isEmpty {
                        Text(card.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
