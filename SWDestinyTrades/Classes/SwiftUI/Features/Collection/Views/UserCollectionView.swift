//
//  UserCollectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct UserCollectionView: View {
    @State private var viewModel: UserCollectionViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container

    @State private var showingFilterSheet = false
    @State private var showingShareSheet = false
    @State private var showToast = false

    init(viewModel: UserCollectionViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: UserCollectionViewModel())
        }
    }

    var body: some View {
        content
            .navigationTitle(L10n.myCollection)
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarContent }
            .refreshable { viewModel.loadCollection() }
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCollection)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .onChange(of: viewModel.sortOption) { _, _ in viewModel.applyFilters() }
            .onChange(of: viewModel.filter) { _, _ in viewModel.applyFilters() }
            .onChange(of: viewModel.showToast) { _, newValue in
                showToast = newValue
            }
            .overlay(alignment: .top) {
                toastView
            }
            .sheet(isPresented: $showingFilterSheet) {
                filterSheet
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [generateShareTextForSheet()])
            }
    }

    @ViewBuilder private var content: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                collectionContent
            }
        }
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.loadCollection()
            }
            if viewModel.availableSets.isEmpty {
                viewModel.loadAvailableSets()
            }
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            filterButton
        }

        ToolbarItemGroup(placement: .navigationBarTrailing) {
            shareButton
            addButton
        }
    }

    @ViewBuilder private var toastView: some View {
        if showToast {
            ToastView(
                title: viewModel.toastTitle,
                message: viewModel.toastMessage,
                type: viewModel.toastType,
                isPresented: $showToast,
                duration: 2.5
            )
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    // MARK: - View Components

    @ViewBuilder private var collectionContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ? L10n.collectionEmpty : L10n.noCardsMatchSearch,
                systemImage: "rectangle.stack"
            )
        } else {
            collectionList
        }
    }

    @ViewBuilder private var collectionList: some View {
        List(viewModel.filteredItems, id: \.code) { card in
            CollectionCardRowView(card: card) { updatedCard, quantity in
                Task {
                    await viewModel.updateCardQuantity(updatedCard, quantity: quantity)
                }
            } onTap: {
                navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
            } onRemove: { card in
                viewModel.removeCard(card)
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
    }

    @ViewBuilder private var filterSheet: some View {
        CollectionFilterView(
            filter: $viewModel.filter,
            sortOption: $viewModel.sortOption,
            availableSets: viewModel.availableSets
        )
    }

    // MARK: - Toolbar Items

    @ViewBuilder private var filterButton: some View {
        FilterToolbarButton(hasActiveFilters: viewModel.hasActiveFilters) {
            showingFilterSheet = true
        }
    }

    @ViewBuilder private var shareButton: some View {
        Button {
            showingShareSheet = true
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }

    @ViewBuilder private var addButton: some View {
        Button {
            navigationCoordinator.navigate(to: .addCard)
        } label: {
            Image(systemName: "plus")
        }
    }

    // MARK: - Helper Methods

    private func generateShareTextForSheet() -> String {
        var collectionText = "\(L10n.myCollection)\n\n"

        for card in viewModel.filteredItems.filter({ $0.quantity > 0 }) {
            collectionText += "\(card.quantity)x \(card.name)\n"
        }

        return collectionText
    }
}

// MARK: - Supporting Views

struct CollectionFilterView: View {
    @Binding var filter: UnifiedCardFilter
    @Binding var sortOption: CollectionSortOption
    let availableSets: [SetDTO]

    @Environment(\.dismiss) private var dismiss

    @State private var tempFilter: UnifiedCardFilter
    @State private var tempSortOption: CollectionSortOption

    init(
        filter: Binding<UnifiedCardFilter>,
        sortOption: Binding<CollectionSortOption>,
        availableSets: [SetDTO]
    ) {
        _filter = filter
        _sortOption = sortOption
        self.availableSets = availableSets
        _tempFilter = State(initialValue: filter.wrappedValue)
        _tempSortOption = State(initialValue: sortOption.wrappedValue)
    }

    private let cardTypes = ["character", "upgrade", "support", "event", "plot", "battlefield", "downgrade"]
    private let cardColors: [(code: String, name: String)] = [
        ("red", "Red"),
        ("blue", "Blue"),
        ("yellow", "Yellow"),
        ("gray", "Gray")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.sortBy) {
                    ForEach(CollectionSortOption.allCases, id: \.self) { option in
                        Toggle(option.displayName, isOn: Binding(
                            get: { tempSortOption == option },
                            set: { isSelected in
                                if isSelected {
                                    tempSortOption = option
                                }
                            }
                        ))
                    }
                }

                Section(L10n.expansions) {
                    Picker(L10n.set, selection: $tempFilter.selectedSet) {
                        Text(L10n.allSets).tag(SetDTO?.none)
                        ForEach(availableSets, id: \.code) { set in
                            Text(set.name).tag(SetDTO?.some(set))
                        }
                    }
                }

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

                Section {
                    Button(L10n.clearAllFilters) {
                        tempFilter.clearAll()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle(L10n.filterCollection)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.cancel) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.apply) {
                        filter = tempFilter
                        sortOption = tempSortOption
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserCollectionView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
