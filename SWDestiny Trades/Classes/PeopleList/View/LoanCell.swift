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
        personNameLabel.text = "\(personDTO.name) \(personDTO.lastName)"
        loanStatusLabel.text = getLoanState(personDTO: personDTO)
    }

    private func getLoanState(personDTO: PersonDTO) -> String {

        var loanState = "No loans"

        let lentMeCount = personDTO.lentMe.count
        let borrowedCount = personDTO.borrowed.count
        if (lentMeCount > 0 && borrowedCount > 0) {
            loanState = "Lent me \(lentMeCount) card & borrowed me \(borrowedCount) card"
        } else if lentMeCount > 0 {
            loanState = "Lent me \(lentMeCount) card"
        } else if borrowedCount > 0 {
           loanState = "Borrowed me \(borrowedCount) card"
        }

        return loanState
    }

    override func prepareForReuse() {
        personNameLabel.text = nil
        loanStatusLabel.text = nil
    }
}
