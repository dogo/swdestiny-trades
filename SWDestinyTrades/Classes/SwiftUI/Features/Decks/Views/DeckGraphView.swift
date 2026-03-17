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
                DeckGraphLoadingView()
            } else if !viewModel.hasData {
                DeckGraphEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        DeckCardTypesChart(
                            hasData: viewModel.hasChartData(for: .cardTypes),
                            title: viewModel.getChartTitle(for: .cardTypes),
                            data: viewModel.cardTypeData,
                            labels: viewModel.cardTypeLabels
                        )
                        DeckCardCostsChart(
                            hasData: viewModel.hasChartData(for: .cardCosts),
                            title: viewModel.getChartTitle(for: .cardCosts),
                            data: viewModel.cardCostData
                        )
                        DeckDiceSymbolsChart(
                            hasData: viewModel.hasChartData(for: .diceSymbols),
                            title: viewModel.getChartTitle(for: .diceSymbols),
                            data: viewModel.diceFaceData,
                            labels: viewModel.diceFaceLabels
                        )
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(L10n.deckStatistics)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            viewModel.refresh()
        }
        .onAppear {
            viewModel.generateGraphData()
        }
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
