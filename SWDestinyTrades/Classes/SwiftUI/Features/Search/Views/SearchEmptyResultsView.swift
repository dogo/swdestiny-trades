//
//  SearchEmptyResultsView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchEmptyResultsView: View {
    let query: String
    let onClear: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(L10n.noResultsFound, systemImage: "magnifyingglass")
        } description: {
            Text(L10n.noCardsMatchViewmodelcurrentqueryTryA(query))
        } actions: {
            Button(L10n.clearSearch, action: onClear)
        }
    }
}
