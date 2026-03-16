//
//  AboutTextSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AboutTextSection: View {
    let onOpenWebsite: () -> Void

    var body: some View {
        let aboutText = L10n.aboutText(L10n.swdestinydbWebsite)
        let components = aboutText.components(separatedBy: L10n.swdestinydbWebsite)

        VStack(alignment: .leading, spacing: 8) {
            if components.count >= 2 {
                Text(components[0])
                    .font(.body)

                Button {
                    onOpenWebsite()
                } label: {
                    Text(L10n.swdestinydbWebsite)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .underline()
                }
                .buttonStyle(.plain)

                Text(components[1])
                    .font(.body)
                    .foregroundStyle(.secondary)
            } else {
                Text(aboutText)
                    .font(.body)
            }
        }
    }
}
