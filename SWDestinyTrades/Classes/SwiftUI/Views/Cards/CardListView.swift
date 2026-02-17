//
//  CardListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardListView: View {
    @State private var viewModel: CardListViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container
    @State private var showingFilterOptions = false
    @State private var showToast = false

    let set: SetDTO

    init(set: SetDTO, viewModel: CardListViewModel? = nil) {
        self.set = set
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: CardListViewModel(set: set))
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                cardListContent
            }
        }
        .navigationTitle(set.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingFilterOptions = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(viewModel.filterOptions.hasActiveFilters ? .blue : .primary)
                }
            }
        }
        .refreshable {
            await refreshCards()
        }
        .searchable(text: $viewModel.searchText, prompt: "Search cards...")
        .sheet(isPresented: $showingFilterOptions) {
            FilterOptionsView(
                filterOptions: $viewModel.filterOptions,
                availableColors: viewModel.availableColors,
                availableTypes: viewModel.availableTypes
            ) {
                showingFilterOptions = false
            }
        }
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
        .onChange(of: viewModel.showToast) { _, newValue in
            showToast = newValue
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .task {
            await viewModel.loadCards()
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: "No Cards Found",
                message: viewModel.searchText.isEmpty ?
                    "Pull to refresh to load cards" :
                    "No cards match your search criteria",
                systemImage: "rectangle.stack"
            )
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                CardRowView(card: card) {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    @MainActor
    private func refreshCards() async {
        await viewModel.loadCards()
    }
}

// MARK: - CardRowView

struct CardRowView: View {
    let card: CardDTO
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
                .frame(width: 60, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(card.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    if !card.subtitle.isEmpty {
                        Text(card.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }

                    HStack {
                        Text(card.typeName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())

                        Text(card.factionName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(factionColor.opacity(0.2))
                            .foregroundColor(factionColor)
                            .clipShape(Capsule())

                        Spacer()
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }

    private var factionColor: Color {
        switch card.factionCode.lowercased() {
        case "red":
            return .red
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "gray", "grey":
            return .gray
        default:
            return .secondary
        }
    }
}

// MARK: - FilterOptionsView

struct FilterOptionsView: View {
    @Binding var filterOptions: CardFilterOptions
    let availableColors: [String]
    let availableTypes: [String]
    let onDismiss: () -> Void

    @State private var tempFilterOptions: CardFilterOptions

    init(filterOptions: Binding<CardFilterOptions>,
         availableColors: [String],
         availableTypes: [String],
         onDismiss: @escaping () -> Void) {
        _filterOptions = filterOptions
        self.availableColors = availableColors
        self.availableTypes = availableTypes
        self.onDismiss = onDismiss
        _tempFilterOptions = State(initialValue: filterOptions.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Colors") {
                    ForEach(availableColors, id: \.self) { color in
                        Toggle(color.capitalized, isOn: Binding(
                            get: { tempFilterOptions.selectedColors.contains(color) },
                            set: { isSelected in
                                if isSelected {
                                    tempFilterOptions.selectedColors.insert(color)
                                } else {
                                    tempFilterOptions.selectedColors.remove(color)
                                }
                            }
                        ))
                    }
                }

                Section("Types") {
                    ForEach(availableTypes, id: \.self) { type in
                        Toggle(type.capitalized, isOn: Binding(
                            get: { tempFilterOptions.selectedTypes.contains(type) },
                            set: { isSelected in
                                if isSelected {
                                    tempFilterOptions.selectedTypes.insert(type)
                                } else {
                                    tempFilterOptions.selectedTypes.remove(type)
                                }
                            }
                        ))
                    }
                }

                Section("Cost Range") {
                    HStack {
                        Text(L10n.minCost)
                        Spacer()
                        TextField("Min", value: $tempFilterOptions.minCost, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                    }

                    HStack {
                        Text(L10n.maxCost)
                        Spacer()
                        TextField("Max", value: $tempFilterOptions.maxCost, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                    }
                }

                Section {
                    Button(L10n.clearAllFilters) {
                        tempFilterOptions.clearAll()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle(L10n.filterCards)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.cancel) {
                        onDismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.apply) {
                        filterOptions = tempFilterOptions
                        onDismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var container: DependencyContainer?
    @Previewable @State var appState: AppState?

    if let container, let appState {
        NavigationStack {
            CardListView(set: SampleData.sets[0])
        }
        .environment(NavigationCoordinator())
        .environment(appState)
        .environment(\.dependencyContainer, container)
    } else {
        ProgressView()
            .task {
                do {
                    container = try await PreviewHelper.createContainer()
                    appState = try await PreviewHelper.createAppState()
                } catch {
                    print("Preview setup failed: \(error)")
                }
            }
    }
}
