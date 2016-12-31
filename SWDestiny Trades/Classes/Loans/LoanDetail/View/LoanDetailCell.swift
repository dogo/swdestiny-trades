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
    @IBOutlet weak var cardSubtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    internal static func cellIdentifier() -> String {
        return "LoanDetailCell"
    }

    internal func configureCell(cardDTO: CardDTO) {
        cardNameLabel.text = cardDTO.name
        cardSubtitleLabel.text = "\(cardDTO.rarityName) -- \(cardDTO.setName)"
        priceLabel.text = ""//cardDTO.price
    }

    override func prepareForReuse() {
        cardNameLabel.text = nil
        cardSubtitleLabel.text = nil
        priceLabel.text = nil
    }
}
