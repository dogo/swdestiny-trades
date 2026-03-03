//
//  UnifiedCardFilter.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct UnifiedCardFilter: Equatable {
    var selectedSet: SetDTO?
    var selectedTypes: Set<String> = []
    var selectedColors: Set<String> = []

    var hasActiveFilters: Bool {
        selectedSet != nil ||
            !selectedTypes.isEmpty ||
            !selectedColors.isEmpty
    }

    var activeFilterCount: Int {
        var count = 0
        if selectedSet != nil { count += 1 }
        count += selectedTypes.count
        count += selectedColors.count
        return count
    }

    mutating func clearAll() {
        selectedSet = nil
        selectedTypes.removeAll()
        selectedColors.removeAll()
    }
}
