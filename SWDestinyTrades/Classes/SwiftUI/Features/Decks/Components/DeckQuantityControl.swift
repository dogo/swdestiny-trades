//
//  DeckQuantityControl.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckQuantityControl: View {
    let card: CardDTO
    @Binding var quantity: Int
    @Binding var isElite: Bool
    let onQuantityChange: (Int) -> Void
    let onEliteToggle: (Bool) -> Void

    var body: some View {
        if card.typeCode == "character", card.isUnique {
            EliteToggleButton(isElite: $isElite) { newValue in
                onEliteToggle(newValue)
            }
        } else if !(card.typeCode == "character" && card.isUnique), card.typeCode != "battlefield" {
            Stepper(L10n.quantity, value: $quantity, in: 1 ... card.deckLimit) { _ in
                onQuantityChange(quantity)
            }
            .labelsHidden()
        }
    }
}
