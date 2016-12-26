//
//  SetsTableCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class SetsTableCell: UITableViewCell {

    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var setIconImage: UIImageView!
    
    internal static func cellIdentifier() -> String {
        return "SetsTableCell"
    }
    
    internal func configureCell(setDTO: SetDTO) {
        setNameLabel.text = setDTO.name
    }
    
    override func prepareForReuse() {
        setNameLabel.text = nil
        setIconImage.image = nil
    }
}
