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
                UnifiedFilterView(
                    filter: $viewModel.filter,
                    availableSets: viewModel.availableSets
                ) {
                    viewModel.applyFilters()
                }
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
        .task {
            await viewModel.loadData()
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ? L10n.pullToRefreshToLoadCards : L10n.noCardsMatchSearch,
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
        FilterToolbarButton(hasActiveFilters: viewModel.filter.hasActiveFilters) {
            showingFilterSheet = true
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

#Preview {
    let mockCollection = UserCollectionDTO()

    AddCardView(context: .collection(mockCollection))
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
