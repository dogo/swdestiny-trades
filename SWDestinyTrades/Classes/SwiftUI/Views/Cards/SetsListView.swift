//
//  SetsListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    @State private var viewModel: SetsListViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container

    @State private var showToast = false

    init(viewModel: SetsListViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: SetsListViewModel())
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                SetsLoadingView()
            } else {
                setsListContent
            }
        }
        .navigationTitle(L10n.expansions)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationCoordinator.navigate(to: .about)
                } label: {
                    Image(systemName: "info.circle")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigationCoordinator.navigate(to: .search)
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .refreshable {
            await refreshSets()
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
        .searchable(text: $viewModel.searchText, prompt: "Search sets...")
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.loadItems()
            }
        }
    }

    @ViewBuilder private var setsListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: "No Sets Found",
                message: viewModel.searchText.isEmpty ?
                    "Pull to refresh to load sets" :
                    "No sets match your search",
                systemImage: "rectangle.stack"
            )
        } else {
            List(viewModel.filteredItems, id: \.code) { set in
                SetRowView(set: set) {
                    navigationCoordinator.navigate(to: .cardList(set))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    @MainActor
    private func refreshSets() async {
        await viewModel.refreshSets()
    }
}

struct SetRowView: View {
    let set: SetDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                set.icon
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundColor(.primary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(set.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Text(set.code.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
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
}

struct SetsLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        SetsListView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
