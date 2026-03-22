//
//  DeckActionButton.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckActionButton: View {
    let isEditing: Bool
    let onSave: () -> Void
    let onStartEditing: () -> Void

    var body: some View {
        if isEditing {
            Button(L10n.done, action: onSave)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
        } else {
            Button(L10n.edit, systemImage: "pencil", action: onStartEditing)
                .labelStyle(.iconOnly)
                .foregroundStyle(ColorPalette.appTheme)
                .buttonStyle(.plain)
        }
    }
}
