//
//  FilterExpansionSection.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct FilterExpansionSection: View {
    @Binding var selectedSet: SetDTO?
    let availableSets: [SetDTO]

    var body: some View {
        Section(L10n.expansions) {
            Picker(L10n.set, selection: $selectedSet) {
                Text(L10n.allSets).tag(SetDTO?.none)
                ForEach(availableSets, id: \.code) { set in
                    Text(set.name).tag(SetDTO?.some(set))
                }
            }
        }
    }
}
