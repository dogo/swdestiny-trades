//
//  CardSearchCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class CardSearchCell: UITableViewCell {

    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardAffiliationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    internal static func cellIdentifier() -> String {
        return "CardSearchCell"
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
