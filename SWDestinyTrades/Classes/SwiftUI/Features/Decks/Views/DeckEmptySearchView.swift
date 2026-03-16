//
//  DeckEmptySearchView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckEmptySearchView: View {
    let searchText: String

    var body: some View {
        ContentUnavailableView.search(text: searchText)
    }
}
