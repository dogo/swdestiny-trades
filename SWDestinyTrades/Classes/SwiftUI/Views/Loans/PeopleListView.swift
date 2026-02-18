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
    @State private var isEditing = false
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
                ProgressView("Loading people...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.filteredItems.isEmpty, !viewModel.searchText.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text(L10n.noPeopleFound)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(L10n.tryAdjustingYourSearchTerms)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.filteredItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text(L10n.noPeopleYet)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(L10n.addPeopleToTrackLoans)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

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
                            if !isEditing {
                                navigationCoordinator.navigate(to: .loanDetail(person.id))
                            }
                        }
                    }
                    .onDelete(perform: deletePeople)
                }
                .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle(L10n.loans)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: "Search people...")
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !viewModel.filteredItems.isEmpty {
                    Button(isEditing ? L10n.done : L10n.edit) {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        withAnimation {
                            isEditing = false
                        }
                    }
                    navigationCoordinator.navigate(to: .newPerson)
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .alert(
            "Delete Person",
            isPresented: $viewModel.showingDeleteConfirmation,
            actions: {
                Button(L10n.delete, role: .destructive) {
                    viewModel.confirmDelete()
                }
                Button(L10n.cancel, role: .cancel) {
                    viewModel.cancelDelete()
                }
            },
            message: {
                if let person = viewModel.personToDelete {
                    Text(L10n.areYouSureYouWantToDeletePersonname(person.name, person.lastName))
                }
            }
        )
        .onAppear {
            viewModel.loadPeople()
        }
        .onReceive(NotificationCenter.default.publisher(for: .personAdded)) { _ in
            viewModel.refresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: .personDeleted)) { _ in
            viewModel.refresh()
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

    private func deletePeople(at offsets: IndexSet) {
        let peopleToDelete = offsets.map { viewModel.filteredItems[$0] }

        if peopleToDelete.count == 1 {
            viewModel.prepareToDelete(peopleToDelete[0])
        } else {
            for person in peopleToDelete {
                viewModel.confirmDelete(person: person)
            }
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
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(person.name) \(person.lastName)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(loanStatusText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    private var loanStatusText: String {
        let lentMeCount = loanSummary.lentCount
        let borrowedCount = loanSummary.borrowedCount

        if lentMeCount > 0, borrowedCount > 0 {
            return "Lent \(lentMeCount) and borrowed \(borrowedCount) cards"
        } else if lentMeCount > 0 {
            return "Lent \(lentMeCount) cards"
        } else if borrowedCount > 0 {
            return "Borrowed \(borrowedCount) cards"
        } else {
            return "No loans"
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
