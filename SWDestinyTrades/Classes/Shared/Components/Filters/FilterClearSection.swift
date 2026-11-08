//
//  FilterClearSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct FilterClearSection: View {
    let onClear: () -> Void

    var body: some View {
        Section {
            Button(L10n.clearAllFilters, action: onClear)
                .foregroundStyle(.red)
        }
    }
}
