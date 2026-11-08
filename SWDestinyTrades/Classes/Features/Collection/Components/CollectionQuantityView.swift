//
//  CollectionQuantityView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionQuantityView: View {
    let card: CardDTO
    @Binding var quantity: Int
    let onChange: (CardDTO, Int) -> Void

    var body: some View {
        HStack {
            Button {
                let newQuantity = max(0, quantity - 1)
                quantity = newQuantity
                onChange(card, newQuantity)
            } label: {
                Image(systemName: "minus.circle")
            }
            .accessibilityLabel(L10n.decreaseQuantity)
            .disabled(quantity <= 0)
            .buttonStyle(.plain)

            Text("\(quantity)")
                .font(.subheadline)
                .bold()
                .frame(minWidth: 30)

            Button {
                let newQuantity = quantity + 1
                quantity = newQuantity
                onChange(card, newQuantity)
            } label: {
                Image(systemName: "plus.circle")
            }
            .accessibilityLabel(L10n.increaseQuantity)
            .buttonStyle(.plain)
        }
        .font(.subheadline)
    }
}
