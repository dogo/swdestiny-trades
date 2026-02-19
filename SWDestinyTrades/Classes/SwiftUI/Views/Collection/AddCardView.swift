//
//  AddCardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddCardView: View {
    @State private var viewModel: AddCardViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss

    @State private var showingFilterSheet = false
    @State private var showToast = false

    init(context: AddCardContext) {
        _viewModel = State(wrappedValue: AddCardViewModel(context: context))
    }

    init(personId: String, type: AddCardType) {
        _viewModel = State(wrappedValue: AddCardViewModel(personId: personId, type: type))
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if viewModel.isLoading, viewModel.items.isEmpty {
                    LoadingView()
                } else {
                    cardListContent
                }
            }
            .navigationTitle(viewModel.addCardContext.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
            .refreshable {
                await refreshCards()
            }
            .sheet(isPresented: $showingFilterSheet) {
                AddCardFilterView(
                    filters: $viewModel.selectedFilters,
                    availableSets: viewModel.availableSets,
                    onApply: {
                        viewModel.applyFilters()
                    }
                )
            }

            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: viewModel.toastType == .success ? 2.0 : 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { _, newValue in
            showToast = newValue
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ?
                    "Pull to refresh to load cards" :
                    "No cards match your search criteria",
                systemImage: "rectangle.stack"
            )
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                AddCardItemRowView(card: card) {
                    viewModel.addCard(card)
                } onDetailTap: {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    @ViewBuilder private var filterButton: some View {
        Button {
            showingFilterSheet = true
        } label: {
            Image(systemName: viewModel.selectedFilters.hasActiveFilters ?
                "line.3.horizontal.decrease.circle.fill" :
                "line.3.horizontal.decrease.circle")
        }
    }

    @MainActor
    private func refreshCards() async {
        await viewModel.loadAllCards()
    }
}

// MARK: - Supporting Views

struct AddCardItemRowView: View {
    let card: CardDTO
    let onAddTap: () -> Void
    let onDetailTap: () -> Void

    var body: some View {
        Button(action: onDetailTap) {
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
                            .lineLimit(2)
                    }

                    HStack {
                        Text(card.setCode.uppercased())
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))

                        Text(card.typeName.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                Button {
                    onAddTap()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct AddCardFilterView: View {
    @Binding var filters: AddCardFilters
    let availableSets: [SetDTO]
    let onApply: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let cardTypes = ["character", "upgrade", "support", "event", "plot", "battlefield"]
    private let cardColors = ["red", "blue", "yellow", "gray"]

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.setFilter) {
                    Picker(L10n.set, selection: $filters.selectedSet) {
                        Text(L10n.allSets).tag(SetDTO?.none)
                        ForEach(availableSets, id: \.code) { set in
                            Text(set.name).tag(SetDTO?.some(set))
                        }
                    }
                }

                Section("Type Filter") {
                    ForEach(cardTypes, id: \.self) { type in
                        Toggle(type.capitalized, isOn: Binding(
                            get: { filters.selectedTypes.contains(type) },
                            set: { isSelected in
                                if isSelected {
                                    filters.selectedTypes.insert(type)
                                } else {
                                    filters.selectedTypes.remove(type)
                                }
                            }
                        ))
                    }
                }

                Section("Color Filter") {
                    ForEach(cardColors, id: \.self) { color in
                        Toggle(color.capitalized, isOn: Binding(
                            get: { filters.selectedColors.contains(color) },
                            set: { isSelected in
                                if isSelected {
                                    filters.selectedColors.insert(color)
                                } else {
                                    filters.selectedColors.remove(color)
                                }
                            }
                        ))
                    }
                }

                Section("Cost Filter") {
                    HStack {
                        Text(L10n.minCost)
                        Spacer()
                        TextField("Min", value: $filters.minCost, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                    }

                    HStack {
                        Text(L10n.maxCost)
                        Spacer()
                        TextField("Max", value: $filters.maxCost, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                    }
                }

                Section {
                    Button(L10n.clearAllFilters) {
                        filters.clearAll()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle(L10n.filterCards)
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
    let mockCollection = UserCollectionDTO()

    AddCardView(context: .collection(mockCollection))
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
