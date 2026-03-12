//
//  FilterToolbarButton.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct FilterToolbarButton: View {
    let hasActiveFilters: Bool
    let action: () -> Void

    var body: some View {
        Button(
            L10n.filterCards,
            systemImage: hasActiveFilters
                ? "line.3.horizontal.decrease.circle.fill"
                : "line.3.horizontal.decrease.circle",
            action: action
        )
        .foregroundStyle(hasActiveFilters ? .blue : .primary)
    }
}
