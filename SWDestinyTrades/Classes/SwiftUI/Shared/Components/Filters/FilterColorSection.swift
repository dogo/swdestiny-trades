//
//  FilterColorSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct FilterColorSection: View {
    @Binding var selectedColors: Set<String>
    let cardColors: [(code: String, name: String)]

    var body: some View {
        Section(L10n.color) {
            ForEach(cardColors, id: \.code) { color in
                Toggle(color.name, isOn: binding(for: color.code))
            }
        }
    }

    private func binding(for value: String) -> Binding<Bool> {
        Binding(
            get: { selectedColors.contains(value) },
            set: { isSelected in
                if isSelected {
                    selectedColors.insert(value)
                } else {
                    selectedColors.remove(value)
                }
            }
        )
    }
}
