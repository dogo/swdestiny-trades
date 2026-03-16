//
//  PlaceholderMainView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct PlaceholderMainView: View {
    var body: some View {
        VStack {
            Text(L10n.swdestinyTrades)
                .font(.largeTitle)
                .bold()

            Text(L10n.swiftuiMigrationInProgress)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(L10n.appInitializedSuccessfully)
                .padding(.top)
                .foregroundStyle(.green)
        }
    }
}
