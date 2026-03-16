//
//  PeopleListContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct PeopleListContent: View {
    let viewModel: PeopleListViewModel

    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    var body: some View {
        if viewModel.isLoading {
            ProgressView(L10n.loadingPeople)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.filteredItems.isEmpty, !viewModel.searchText.isEmpty {
            ContentUnavailableView.search
        } else if viewModel.filteredItems.isEmpty {
            ContentUnavailableView(
                L10n.noPeopleYet,
                systemImage: "person.2",
                description: Text(L10n.addPeopleToTrackLoans)
            )
        } else {
            List {
                ForEach(viewModel.filteredItems, id: \.id) { person in
                    PersonRowView(
                        person: person,
                        loanSummary: viewModel.getLoanSummary(for: person)
                    ) {
                        navigationCoordinator.navigate(to: .loanDetail(person.id))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(L10n.delete, role: .destructive) {
                            Task {
                                await viewModel.deletePerson(person)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}
