//
//  LoanDetailCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class LoanDetailCell: UITableViewCell, Reusable, BaseViewConfiguration {
    
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

    internal func configureCell(cardDTO: CardDTO) {
        baseViewCell.titleLabel.text = cardDTO.name
        baseViewCell.subtitleLabel.text = "\(cardDTO.rarityName) -- \(cardDTO.setName)"
        baseViewCell.accessoryLabel.text = ""//cardDTO.price
    }

    override func prepareForReuse() {
        baseViewCell.titleLabel.text = nil
        baseViewCell.subtitleLabel.text = nil
        baseViewCell.accessoryLabel.text = nil
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
