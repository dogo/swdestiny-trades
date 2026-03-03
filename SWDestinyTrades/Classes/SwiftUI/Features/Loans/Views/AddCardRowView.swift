//
//  AddCardRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddCardRowView: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)

                Text(text)
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
