//
//  CollectionCardRowView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionCardRowView: View {
    let card: CardDTO
    let onQuantityChange: (CardDTO, Int) -> Void
    let onTap: () -> Void
    let onRemove: (CardDTO) -> Void

    @State private var quantity: Int

    init(card: CardDTO, onQuantityChange: @escaping (CardDTO, Int) -> Void, onTap: @escaping () -> Void, onRemove: @escaping (CardDTO) -> Void) {
        self.card = card
        self.onQuantityChange = onQuantityChange
        self.onTap = onTap
        self.onRemove = onRemove
        _quantity = State(initialValue: card.quantity)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                iconView
                cardInfoView
                Spacer()
                quantityView
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .onChange(of: card.quantity) { _, newValue in
            quantity = newValue
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(L10n.delete, role: .destructive) {
                onRemove(card)
            }
        }
    }

    private var cardInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            if !card.subtitle.isEmpty {
                Text(card.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text(card.setCode.uppercased())
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                Text(card.typeName.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }
        }
    }

    private var iconView: some View {
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
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var quantityView: some View {
        HStack {
            Button {
                let newQuantity = max(0, quantity - 1)
                quantity = newQuantity
                onQuantityChange(card, newQuantity)
            } label: {
                Image(systemName: "minus.circle")
            }
            .disabled(quantity <= 0)
            .buttonStyle(.plain)

            Text("\(quantity)")
                .font(.subheadline)
                .bold()
                .frame(minWidth: 30)

            Button {
                let newQuantity = quantity + 1
                quantity = newQuantity
                onQuantityChange(card, newQuantity)
            } label: {
                Image(systemName: "plus.circle")
            }
            .buttonStyle(.plain)
        }
        .font(.subheadline)
    }
}
