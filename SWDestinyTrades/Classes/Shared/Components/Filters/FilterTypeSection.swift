//
//  FilterTypeSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct FilterTypeSection: View {
    @Binding var selectedTypes: Set<String>
    let cardTypes: [String]

    var body: some View {
        Section(L10n.cardTypes) {
            ForEach(cardTypes, id: \.self) { type in
                Toggle(type.capitalized, isOn: binding(for: type))
            }
        }
    }

    private func binding(for value: String) -> Binding<Bool> {
        Binding(
            get: { selectedTypes.contains(value) },
            set: { isSelected in
                if isSelected {
                    selectedTypes.insert(value)
                } else {
                    selectedTypes.remove(value)
                }
            }
        )
    }
}
