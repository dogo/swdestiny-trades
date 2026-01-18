//
//  UserCollectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct UserCollectionView: View {
    @StateObject private var viewModel: UserCollectionViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container

    @State private var showingFilterSheet = false
    @State private var showingShareSheet = false
    @State private var showToast = false

    init(viewModel: UserCollectionViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: UserCollectionViewModel())
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading, viewModel.items.isEmpty {
                    LoadingView()
                } else {
                    collectionContent
                }
            }
            .navigationTitle(L10n.myCollection)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    filterButton
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    shareButton
                    addButton
                }
            }
            .refreshable {
                await refreshCollection()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search collection...")
            .overlay(alignment: .top) {
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
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
            .onChange(of: viewModel.showToast) { newValue in
                showToast = newValue
            }
            .sheet(isPresented: $showingFilterSheet) {
                CollectionFilterView(
                    filterOptions: $viewModel.filterOptions,
                    selectedSet: $viewModel.selectedSet,
                    sortOption: $viewModel.sortOption,
                    availableSets: viewModel.availableSets
                ) {
                    viewModel.updateFilterOptions(viewModel.filterOptions)
                    viewModel.updateSelectedSet(viewModel.selectedSet)
                    viewModel.updateSortOption(viewModel.sortOption)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [generateShareTextForSheet()])
            }
        }
    }

    @ViewBuilder private var collectionContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: "No Cards Found",
                message: viewModel.searchText.isEmpty ?
                    "Your collection is empty. Tap + to add cards." :
                    "No cards match your search criteria",
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
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
    }

    // MARK: - Toolbar Items

    @ViewBuilder private var filterButton: some View {
        Button {
            showingFilterSheet = true
        } label: {
            Image(systemName: viewModel.filterOptions.hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
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

    @MainActor
    private func refreshCollection() async {
        viewModel.loadCollection()

        while viewModel.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }

    private func generateShareTextForSheet() -> String {
        var collectionText = "\(L10n.myCollection)\n\n"

        for card in viewModel.filteredItems.filter({ $0.quantity > 0 }) {
            collectionText += "\(card.quantity)x \(card.name)\n"
        }

        return collectionText
    }
}

// MARK: - Supporting Views

struct CollectionCardRowView: View {
    let card: CardDTO
    let onQuantityChange: (CardDTO, Int) -> Void
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: card.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Image(asset: Asset.icCardback)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.3)

                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .frame(width: 40, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack(alignment: .leading, spacing: 4) {
                    Text(card.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    if !card.subtitle.isEmpty {
                        Text(card.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text(card.setCode.uppercased())
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))

                        Text(card.typeCode.capitalized)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                HStack {
                    Button {
                        onQuantityChange(card, max(0, card.quantity - 1))
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .disabled(card.quantity <= 0)
                    .buttonStyle(.plain)

                    Text(L10n.cardquantity(card.quantity))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(minWidth: 30)

                    Button {
                        onQuantityChange(card, card.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(.plain)
                }
                .font(.subheadline)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct CollectionFilterView: View {
    @Binding var filterOptions: CollectionFilterOptions
    @Binding var selectedSet: SetDTO?
    @Binding var sortOption: CollectionSortOption
    let availableSets: [SetDTO]
    let onApply: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Sort By") {
                    ForEach(CollectionSortOption.allCases, id: \.self) { option in
                        Toggle(option.displayName, isOn: Binding(
                            get: { sortOption == option },
                            set: { isSelected in
                                if isSelected {
                                    sortOption = option
                                }
                            }
                        ))
                    }
                }

                Section("Set Filter") {
                    Picker("Set", selection: $selectedSet) {
                        Text(L10n.allSets).tag(SetDTO?.none)
                        ForEach(availableSets, id: \.code) { set in
                            Text(set.name).tag(SetDTO?.some(set))
                        }
                    }
                }

                Section {
                    Button(L10n.clearAllFilters) {
                        filterOptions.clearAll()
                        selectedSet = nil
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
                        onApply()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        UserCollectionView()
    }
    .environmentObject(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
