//
//  LoansRootView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LoansRootView: View {
    @State private var viewModel = PeopleListViewModel()

    var body: some View {
        PeopleListView(viewModel: viewModel)
    }
}
