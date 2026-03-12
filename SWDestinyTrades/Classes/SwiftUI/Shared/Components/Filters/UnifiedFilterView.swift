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
                    expansionSection
                }
                typeSection
                colorSection
                clearSection
            }
            .navigationTitle(L10n.filterCards)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
    }

    // MARK: - Toolbar

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

    // MARK: - Sections

    @ViewBuilder private var expansionSection: some View {
        Section(L10n.expansions) {
            Picker(L10n.set, selection: $tempFilter.selectedSet) {
                Text(L10n.allSets).tag(SetDTO?.none)
                ForEach(availableSets, id: \.code) { set in
                    Text(set.name).tag(SetDTO?.some(set))
                }
            }
        }
    }

    @ViewBuilder private var typeSection: some View {
        Section(L10n.cardTypes) {
            ForEach(cardTypes, id: \.self) { type in
                Toggle(type.capitalized, isOn: Binding(
                    get: { tempFilter.selectedTypes.contains(type) },
                    set: { isSelected in
                        if isSelected {
                            tempFilter.selectedTypes.insert(type)
                        } else {
                            tempFilter.selectedTypes.remove(type)
                        }
                    }
                ))
            }
        }
    }

    @ViewBuilder private var colorSection: some View {
        Section(L10n.color) {
            ForEach(cardColors, id: \.code) { color in
                Toggle(color.name, isOn: Binding(
                    get: { tempFilter.selectedColors.contains(color.code) },
                    set: { isSelected in
                        if isSelected {
                            tempFilter.selectedColors.insert(color.code)
                        } else {
                            tempFilter.selectedColors.remove(color.code)
                        }
                    }
                ))
            }
        }
    }

    @ViewBuilder private var clearSection: some View {
        Section {
            Button(L10n.clearAllFilters) {
                tempFilter.clearAll()
            }
            .foregroundColor(.red)
        }
    }
}

// MARK: - Filter Button Helper

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
