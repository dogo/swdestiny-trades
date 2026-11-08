//
//  DeckDiceSymbolsChart.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckDiceSymbolsChart: View {
    let hasData: Bool
    let title: String
    let data: [Int]
    let labels: [String]

    var body: some View {
        if hasData {
            ChartCardView(title: title) {
                SwiftUIRadarChartView(data: data, labels: labels, title: title)
                    .frame(height: 300)
            }
        }
    }
}
