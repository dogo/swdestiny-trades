//
//  CardFlavorSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardFlavorSection: View {
    let flavor: String

    var body: some View {
        if !flavor.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.flavorText)
                    .font(.headline)
                    .foregroundStyle(.primary)

                flavor.toCardText()
                    .font(.body)
                    .italic()
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
