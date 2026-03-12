//
//  CollectionRootView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CollectionRootView: View {
    @State private var viewModel = UserCollectionViewModel()

    var body: some View {
        UserCollectionView(viewModel: viewModel)
    }
}
