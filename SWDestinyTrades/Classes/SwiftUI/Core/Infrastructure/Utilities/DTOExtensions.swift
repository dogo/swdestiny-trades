//
//  DTOExtensions.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

// MARK: - PersonDTO Extensions

extension PersonDTO {
    var borrowedCount: Int {
        borrowed.reduce(0) { $0 + $1.quantity }
    }

    var lentCount: Int {
        lentMe.reduce(0) { $0 + $1.quantity }
    }

    var totalLoanCount: Int {
        borrowedCount + lentCount
    }

    var hasLoans: Bool {
        totalLoanCount > 0
    }
}

// MARK: - DeckDTO Extensions

extension DeckDTO {
    var cardCount: Int {
        list.reduce(0) { $0 + $1.quantity }
    }
}

// MARK: - UserCollectionDTO Extensions

extension UserCollectionDTO {
    var cardCount: Int {
        myCollection.count
    }
}
