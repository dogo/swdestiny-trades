//
//  CardCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class CardCell: UITableViewCell, Reusable, BaseViewConfiguration {

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

    internal func configureCell(card: CardDTO, useIndex: Bool) {
        baseViewCell.titleLabel.text = card.name
        sdskd(card: card, useIndex: useIndex)
        baseViewCell.accessoryLabel.text = ""//cardDTO.price
    }
    
    private func sdskd(card: CardDTO, useIndex: Bool) {
        if useIndex {
            baseViewCell.subtitleLabel.text = "#\(card.code.subString(from: 2)), \(card.affiliationName)"
        } else {
            baseViewCell.subtitleLabel.text = card.affiliationName
        }
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
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
