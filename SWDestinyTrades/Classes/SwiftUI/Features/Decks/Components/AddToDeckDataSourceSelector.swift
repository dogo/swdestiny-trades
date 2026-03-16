//
//  AddToDeckDataSourceSelector.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddToDeckDataSourceSelector: View {
    let dataSource: AddToDeckViewModel.DataSource
    let onSelectRemote: () -> Void
    let onSelectLocal: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onSelectRemote) {
                Text(L10n.remote)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(dataSource == .remote ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(dataSource == .remote ? Color.blue : Color.clear)
            }

            Button(action: onSelectLocal) {
                Text(L10n.local)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(dataSource == .local ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(dataSource == .local ? Color.blue : Color.clear)
            }
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 8))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
