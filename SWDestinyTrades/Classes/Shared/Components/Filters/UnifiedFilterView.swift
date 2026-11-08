//
//  UnifiedFilterView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct UnifiedFilterView: View {
    @Binding var filter: UnifiedCardFilter
    let availableSets: [SetDTO]
    let showExpansionFilter: Bool
    let onApply: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var tempFilter: UnifiedCardFilter

    private let cardTypes = ["character", "upgrade", "support", "event", "plot", "battlefield", "downgrade"]
    private let cardColors: [(code: String, name: String)] = [
        ("red", "Red"),
        ("blue", "Blue"),
        ("yellow", "Yellow"),
        ("gray", "Gray")
    ]

    init(
        filter: Binding<UnifiedCardFilter>,
        availableSets: [SetDTO] = [],
        showExpansionFilter: Bool = true,
        onApply: @escaping () -> Void
    ) {
        _filter = filter
        self.availableSets = availableSets
        self.showExpansionFilter = showExpansionFilter
        self.onApply = onApply
        _tempFilter = State(initialValue: filter.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                if showExpansionFilter {
                    FilterExpansionSection(selectedSet: $tempFilter.selectedSet, availableSets: availableSets)
                }
                FilterTypeSection(selectedTypes: $tempFilter.selectedTypes, cardTypes: cardTypes)
                FilterColorSection(selectedColors: $tempFilter.selectedColors, cardColors: cardColors)
                FilterClearSection { tempFilter.clearAll() }
            }
            .navigationTitle(L10n.filterCards)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(L10n.cancel) {
                dismiss()
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button(L10n.apply) {
                filter = tempFilter
                onApply()
                dismiss()
            }
        }
    }
}
