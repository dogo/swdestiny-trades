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
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @State private var showToast = false

    init(viewModel: PeopleListViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: PeopleListViewModel())
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(L10n.loadingPeople)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.filteredItems.isEmpty, !viewModel.searchText.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2.slash")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text(L10n.noPeopleFound)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(L10n.tryAdjustingYourSearchTerms)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.filteredItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text(L10n.noPeopleYet)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(L10n.addPeopleToTrackLoans)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button(L10n.addPerson) {
                        navigationCoordinator.navigate(to: .newPerson)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
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
    }
}

struct PersonRowView: View {
    let person: PersonDTO
    let loanSummary: LoanSummary
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(PersonNameComponents(givenName: person.name, familyName: person.lastName).formatted(.name(style: .long)))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    loanStatusView
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var loanStatusView: some View {
        let lentCount = loanSummary.lentCount
        let borrowedCount = loanSummary.borrowedCount

        if lentCount == 0, borrowedCount == 0 {
            Label(L10n.noLoans, systemImage: "checkmark.circle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                if lentCount > 0 {
                    Label(L10n.lentMeCard(lentCount), systemImage: "arrow.up.right")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                if borrowedCount > 0 {
                    Label(L10n.borrowedCard(borrowedCount), systemImage: "arrow.down.left")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}

// MARK: - Previews

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListView()
            .environment(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
            .previewDisplayName("People List - Light")

        PeopleListView()
            .environment(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
            .preferredColorScheme(.dark)
            .previewDisplayName("People List - Dark")
    }
}
