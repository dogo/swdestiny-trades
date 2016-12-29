//
//  LoanDetailCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class LoanDetailCell: UITableViewCell {

    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardAffiliationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    internal static func cellIdentifier() -> String {
        return "LoanDetailCell"
    }

    internal func configureCell(cardDTO: CardDTO) {
        cardNameLabel.text = cardDTO.name
        cardAffiliationLabel.text = "\(cardDTO.setName) -- \(cardDTO.rarityName)"
        priceLabel.text = ""//cardDTO.price
    }

    override func prepareForReuse() {
        cardNameLabel.text = nil
        cardAffiliationLabel.text = nil
        priceLabel.text = nil
    }
}
