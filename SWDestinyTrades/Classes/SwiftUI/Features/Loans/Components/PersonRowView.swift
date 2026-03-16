//
//  PersonRowView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct PersonRowView: View {
    let person: PersonDTO
    let loanSummary: LoanSummary
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(PersonNameComponents(givenName: person.name, familyName: person.lastName).formatted(.name(style: .long)))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    LoanStatusView(loanSummary: loanSummary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
