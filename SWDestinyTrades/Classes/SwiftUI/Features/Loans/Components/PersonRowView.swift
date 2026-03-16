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

                    loanStatusView
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

    @ViewBuilder private var loanStatusView: some View {
        let lentCount = loanSummary.lentCount
        let borrowedCount = loanSummary.borrowedCount

        if lentCount == 0, borrowedCount == 0 {
            Label(L10n.noLoans, systemImage: "checkmark.circle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                if lentCount > 0 {
                    Label(L10n.lentMeCard(lentCount), systemImage: "arrow.up.right")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                if borrowedCount > 0 {
                    Label(L10n.borrowedCard(borrowedCount), systemImage: "arrow.down.left")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}
