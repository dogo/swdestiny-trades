//
//  DeckCardCostsChart.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckCardCostsChart: View {
    let hasData: Bool
    let title: String
    let data: [Int]

    var body: some View {
        if hasData {
            ChartCardView(title: title) {
                SwiftUILineChartView(data: data, title: title)
                    .frame(height: 300)
            }
        }
    }
}
