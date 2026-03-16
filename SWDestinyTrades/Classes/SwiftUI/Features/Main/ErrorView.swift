//
//  ErrorView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text(L10n.error)
                .font(.title)
                .bold()

            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(L10n.retry) {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
