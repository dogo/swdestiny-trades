//
//  LoanCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class LoanCell: UITableViewCell {

    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var loanStatusLabel: UILabel!

    internal static func cellIdentifier() -> String {
        return "LoanCell"
    }

    internal func configureCell(cardDTO: String) {
        personNameLabel.text = cardDTO
        //loanStatusLabel.text = cardDTO.affiliationName
    }

    override func prepareForReuse() {
        personNameLabel.text = nil
        //loanStatusLabel.text = nil
    }
}
