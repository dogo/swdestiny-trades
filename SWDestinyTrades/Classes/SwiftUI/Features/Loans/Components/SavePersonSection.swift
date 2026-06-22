//
//  SavePersonSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SavePersonSection: View {
    let isLoading: Bool
    let isDisabled: Bool
    let onSave: () -> Void

    var body: some View {
        Section {
            Button(action: onSave) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }

                    Text(L10n.savePerson)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(isDisabled)
            .buttonStyle(.borderedProminent)
            .tint(ColorPalette.appTheme)
            .foregroundStyle(ColorPalette.appThemeForeground)
        }
    }
}
