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
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @State private var showingFilterSheet = false
    @State private var shareItem: ShareText?

    init(viewModel: UserCollectionViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? UserCollectionViewModel())
    }

    var body: some View {
        CollectionContent(viewModel: viewModel)
            .navigationTitle(L10n.myCollection)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    FilterToolbarButton(hasActiveFilters: viewModel.hasActiveFilters) {
                        showingFilterSheet = true
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(L10n.share, systemImage: "square.and.arrow.up") {
                        shareItem = ShareText(value: viewModel.shareText)
                    }
                    Button(L10n.addCard, systemImage: "plus") {
                        navigationCoordinator.navigate(to: .addCard)
                    }
                }
            }
            .refreshable { await viewModel.refreshCollection() }
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCollection)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .onChange(of: viewModel.filter) { _, _ in viewModel.applyFilters() }
            .toastQueue(viewModel.toastQueue)
            .sheet(isPresented: $showingFilterSheet) {
                UnifiedFilterView(
                    filter: $viewModel.filter,
                    availableSets: viewModel.availableSets
                ) {
                    viewModel.applyFilters()
                }
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: [item.value])
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
