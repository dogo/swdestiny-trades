//
//  EliteToggleButton.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct EliteToggleButton: View {
    @Binding var isElite: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        Button {
            isElite.toggle()
            onToggle(isElite)
        } label: {
            Text(isElite ? L10n.elite : L10n.nonElite)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isElite ? Color.primary : Color.clear)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .foregroundStyle(isElite ? Color(.systemBackground) : Color.primary)
        }
        .buttonStyle(.plain)
    }
}
