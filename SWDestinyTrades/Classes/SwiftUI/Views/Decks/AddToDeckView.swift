//
//  AddToDeckView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddToDeckView: View {
    @StateObject private var viewModel: AddToDeckViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container

    @State private var showToast = false

    init(deck: DeckDTO, viewModel: AddToDeckViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: AddToDeckViewModel(deck: deck))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            dataSourceSelector

            if viewModel.isLoading {
                LoadingView()
            } else {
                cardsList
            }
        }
        .navigationTitle(L10n.addCard)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Search cards...")
        .onSubmit(of: .search) {}
        .overlay(alignment: .top) {
            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: viewModel.toastType == .success ? 2.0 : (viewModel.toastType == .error ? 2.5 : 1.5)
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { newValue in
            showToast = newValue
        }
    }

    @ViewBuilder private var dataSourceSelector: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.loadRemoteCards()
            } label: {
                Text(L10n.remote)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.dataSource == .remote ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.dataSource == .remote ? Color.blue : Color.clear)
            }

            Button {
                viewModel.loadLocalCards()
            } label: {
                Text(L10n.local)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.dataSource == .local ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.dataSource == .local ? Color.blue : Color.clear)
            }
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    @ViewBuilder private var cardsList: some View {
        if viewModel.filteredItems.isEmpty {
            EmptyStateView(
                title: "No Cards Found",
                message: viewModel.searchText.isEmpty ?
                    (viewModel.dataSource == .remote ? "Pull to refresh to load cards" : "No cards in your collection") :
                    "No cards match your search",
                systemImage: "rectangle.stack"
            )
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                AddToDeckCardRowView(card: card) {
                    viewModel.addCardToDeck(card)
                } onDetailTap: {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
            .refreshable {
                if viewModel.dataSource == .remote {
                    viewModel.loadRemoteCards()
                } else {
                    viewModel.loadLocalCards()
                }
            }
        }
    }
}

struct AddToDeckCardRowView: View {
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

                        Text(card.typeCode.capitalized)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: 8) {
                    Button {
                        onDetailTap()
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)

                    Button {
                        onAddTap()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
