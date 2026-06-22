//
//  SearchResultRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchResultRowView: View {
    let card: CardDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                cardImage
                cardInfo
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }

    private var cardImage: some View {
        CardImageView(
            imageUrl: card.imageUrl,
            width: 40,
            height: 56,
            cornerRadius: 4
        )
    }

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            if !card.subtitle.isEmpty {
                Text(card.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Text(card.setCode.uppercased())
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray5))
                    .clipShape(.rect(cornerRadius: 4))

                Text(card.typeCode.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
