//
//  SearchView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? SearchViewModel())
    }

    var body: some View {
        SearchContent(viewModel: viewModel)
            .navigationTitle(L10n.search)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
            .onSubmit(of: .search) {
                if !viewModel.searchText.isEmpty {
                    viewModel.performSearch(query: viewModel.searchText)
                }
            }
            .toastQueue(viewModel.toastQueue)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.onSearchTextChanged(newValue)
            }
    }
}

#Preview {
    SearchView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
