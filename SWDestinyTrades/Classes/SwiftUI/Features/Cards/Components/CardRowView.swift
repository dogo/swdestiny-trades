//
//  CardRowView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardRowView: View {
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
        .frame(width: 60, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
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
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            HStack {
                Text(card.typeName.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())

                Text(card.factionName.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(card.factionColor().opacity(0.2))
                    .foregroundStyle(card.factionColor())
                    .clipShape(Capsule())

                Spacer()
            }
        }
    }
}
