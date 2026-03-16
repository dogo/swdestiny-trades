//
//  CardTextSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardTextSection: View {
    let text: String
    @ScaledMetric private var iconSize: CGFloat = 17

    var body: some View {
        if !text.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.cardText)
                    .font(.headline)
                    .foregroundStyle(.primary)

                text.toCardText(iconSize: iconSize)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
