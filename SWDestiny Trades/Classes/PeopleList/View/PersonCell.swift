//
//  PersonCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class PersonCell: UITableViewCell, Reusable, BaseViewConfiguration {

    var baseViewCell = BaseViewCell()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(personDTO: PersonDTO) {
        baseViewCell.titleLabel.text = "\(personDTO.name) \(personDTO.lastName)"
        baseViewCell.subtitleLabel.text = getLoanState(personDTO: personDTO)
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
        baseViewCell.titleLabel.text = nil
        baseViewCell.titleLabel.text = nil
    }
    
    // MARK: <BaseViewConfiguration>
    
    internal func buildViewHierarchy() {
        self.contentView.addSubview(baseViewCell)
    }
    
    internal func setupConstraints() {
        baseViewCell.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
