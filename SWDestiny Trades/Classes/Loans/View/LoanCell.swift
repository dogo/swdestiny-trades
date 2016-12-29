//
//  LoanCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

class LoanCell: UITableViewCell {

    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var loanStatusLabel: UILabel!

    internal static func cellIdentifier() -> String {
        return "LoanCell"
    }

    internal func configureCell(personDTO: PersonDTO) {
        personNameLabel.text = personDTO.name
        loanStatusLabel.text = getLoanState(loans: personDTO.loans)
    }
    
    private func getLoanState(loans: List<LoanDTO>) -> String {
        
        var loanState = "No loans"
        if loans.count > 0 {
            let lentMeCount = loans.filter("hasLentMe == true").count
            let borrowedCount = loans.filter("hasLentMe == false").count
            if (lentMeCount > 0 && borrowedCount > 0) {
                loanState = "Lent me \(lentMeCount) card & borrowed me \(lentMeCount) card"
            } else if lentMeCount > 0 {
                loanState = "Lent me \(lentMeCount) card"
            } else if borrowedCount > 0 {
               loanState = "Borrowed me \(lentMeCount) card"
            }
        }
        return loanState
    }

    override func prepareForReuse() {
        personNameLabel.text = nil
        loanStatusLabel.text = nil
    }
}
