//
//  LoanCardRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LoanCardRowView: View {
    let card: CardDTO
    let onQuantityChanged: (Int) -> Void
    let onTap: () -> Void

    @State private var quantity: Int

    init(card: CardDTO, onQuantityChanged: @escaping (Int) -> Void, onTap: @escaping () -> Void) {
        self.card = card
        self.onQuantityChanged = onQuantityChanged
        self.onTap = onTap
        _quantity = State(initialValue: card.quantity)
    }

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

                    Text(card.setName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Stepper("", value: $quantity, in: 1 ... 99)
                    .labelsHidden()
                    .onChange(of: quantity) { _, newValue in
                        onQuantityChanged(newValue)
                    }

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
