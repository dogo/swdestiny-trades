//
//  PeopleListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct PeopleListView: View {
    @State private var viewModel: PeopleListViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(viewModel: PeopleListViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? PeopleListViewModel())
    }

    var body: some View {
        PeopleListContent(viewModel: viewModel)
            .navigationTitle(L10n.loans)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: L10n.searchPeople)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.addPerson, systemImage: "plus") {
                        navigationCoordinator.navigate(to: .newPerson)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadPeople()
                }
            }
            .toastQueue(viewModel.toastQueue)
    }
}

#Preview("People List - Light") {
    PeopleListView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}

#Preview("People List - Dark") {
    PeopleListView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
        .preferredColorScheme(.dark)
}
