//
//  LoanStatusView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct LoanStatusView: View {
    let loanSummary: LoanSummary

    var body: some View {
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
