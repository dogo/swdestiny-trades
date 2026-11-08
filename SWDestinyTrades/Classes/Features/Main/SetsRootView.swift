//
//  SetsRootView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SetsRootView: View {
    @State private var viewModel = SetsListViewModel()

    var body: some View {
        SetsListView(viewModel: viewModel)
    }
}
