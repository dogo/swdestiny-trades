//
//  DeckGraphView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckGraphView: View {
    @State private var viewModel: DeckGraphViewModel

    init(deck: DeckDTO, dependencyContainer: DependencyContainer = .shared) {
        _viewModel = State(wrappedValue: DeckGraphViewModel(deck: deck, dependencyContainer: dependencyContainer))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if !viewModel.hasData {
                emptyStateView
            } else {
                chartsScrollView
            }
        }
        .navigationTitle(L10n.deckStatistics)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            refreshData()
        }
        .onAppear {
            viewModel.generateGraphData()
        }
    }

    // MARK: - View Components

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(L10n.generatingCharts)
                .foregroundStyle(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(L10n.noDataAvailable)
                .font(.title2)
                .bold()

            Text(L10n.addCardsToYourDeckToSeeStatistics)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var chartsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                cardTypesChart
                cardCostsChart
                diceSymbolsChart
            }
            .padding()
        }
    }

    @ViewBuilder private var cardTypesChart: some View {
        if viewModel.hasChartData(for: .cardTypes) {
            ChartCardView(title: viewModel.getChartTitle(for: .cardTypes)) {
                SwiftUIBarChartView(
                    data: viewModel.cardTypeData,
                    labels: viewModel.cardTypeLabels,
                    title: viewModel.getChartTitle(for: .cardTypes)
                )
                .frame(height: 300)
            }
        }
    }

    @ViewBuilder private var cardCostsChart: some View {
        if viewModel.hasChartData(for: .cardCosts) {
            ChartCardView(title: viewModel.getChartTitle(for: .cardCosts)) {
                SwiftUILineChartView(
                    data: viewModel.cardCostData,
                    title: viewModel.getChartTitle(for: .cardCosts)
                )
                .frame(height: 300)
            }
        }
    }

    @ViewBuilder private var diceSymbolsChart: some View {
        if viewModel.hasChartData(for: .diceSymbols) {
            ChartCardView(title: viewModel.getChartTitle(for: .diceSymbols)) {
                SwiftUIRadarChartView(
                    data: viewModel.diceFaceData,
                    labels: viewModel.diceFaceLabels,
                    title: viewModel.getChartTitle(for: .diceSymbols)
                )
                .frame(height: 300)
            }
        }
    }

    // MARK: - Actions

    private func refreshData() {
        viewModel.refresh()
    }
}

// MARK: - Preview

#Preview {
    let sampleDeck = DeckDTO()
    sampleDeck.name = "Sample Deck"

    // Add some sample cards for preview
    let sampleCard1 = CardDTO()
    sampleCard1.name = "Sample Upgrade"
    sampleCard1.typeCode = "upgrade"
    sampleCard1.quantity = 2
    sampleCard1.cost = 2

    let sampleCard2 = CardDTO()
    sampleCard2.name = "Sample Event"
    sampleCard2.typeCode = "event"
    sampleCard2.quantity = 1
    sampleCard2.cost = 1

    sampleDeck.list.append(sampleCard1)
    sampleDeck.list.append(sampleCard2)

    return NavigationStack {
        DeckGraphView(deck: sampleDeck)
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}

#Preview("Empty Deck") {
    let emptyDeck = DeckDTO()
    emptyDeck.name = "Empty Deck"

    return NavigationStack {
        DeckGraphView(deck: emptyDeck)
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}
