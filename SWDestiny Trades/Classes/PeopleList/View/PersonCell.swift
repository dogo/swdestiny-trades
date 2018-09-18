//
//  PersonCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class PersonCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.textColor = .darkGray
        self.accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(personDTO: PersonDTO) {
        textLabel?.text = "\(personDTO.name) \(personDTO.lastName)"
        detailTextLabel?.text = getLoanState(personDTO: personDTO)
        detailTextLabel?.adjustsFontSizeToFitWidth = true
    }

    private func getLoanState(personDTO: PersonDTO) -> String {

        var loanState = L10n.noLoans
        let lentMeCount = personDTO.lentMe.sum(ofProperty: "quantity") as Int
        let borrowedCount = personDTO.borrowed.sum(ofProperty: "quantity") as Int
        if lentMeCount > 0 && borrowedCount > 0 {
            loanState = String.localizedStringWithFormat(NSLocalizedString("LENT_ME_AND_BORROWED_CARDS", comment: ""), lentMeCount, borrowedCount)
        } else if lentMeCount > 0 {
            loanState = String.localizedStringWithFormat(NSLocalizedString("LENT_ME_CARD", comment: ""), lentMeCount)
        } else if borrowedCount > 0 {
            loanState = String.localizedStringWithFormat(NSLocalizedString("BORROWED_CARD", comment: ""), borrowedCount)
        }

        return loanState
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }
}
