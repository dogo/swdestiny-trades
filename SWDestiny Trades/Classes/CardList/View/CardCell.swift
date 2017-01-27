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
        setSubtitle(card: card, useIndex: useIndex)
        setIconImage(card: card)
        baseViewCell.accessoryLabel.text = ""//cardDTO.price
    }

    private func setSubtitle(card: CardDTO, useIndex: Bool) {
        if useIndex {
            baseViewCell.subtitleLabel.text = "#\(card.code.subString(from: 2))"
            if card.subtitle.isNotEmpty {
                baseViewCell.subtitleLabel.text?.append(", \(card.subtitle)")
            }
        } else {
            baseViewCell.subtitleLabel.text = "\(card.subtitle)"
        }
        
        guard baseViewCell.subtitleLabel.text?.trim() == "" else {
            baseViewCell.titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(baseViewCell.contentView)
                make.left.equalTo(baseViewCell.iconImageView.snp.right).offset(12)
            }
            return
        }
        baseViewCell.titleLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(baseViewCell.contentView)
            make.left.equalTo(baseViewCell.iconImageView.snp.right).offset(12)
        }
    }
    
    private func setIconImage(card: CardDTO) {
        let imageForRendering = UIImage(named: "ic_\(card.typeCode)")?.withRenderingMode(.alwaysTemplate)
        baseViewCell.iconImageView.image = imageForRendering
        
        if card.factionCode == "red" {
            baseViewCell.iconImageView.tintColor = ColorPalette.red
        } else if card.factionCode == "yellow" {
            baseViewCell.iconImageView.tintColor = ColorPalette.yellow
        } else if card.factionCode == "blue" {
            baseViewCell.iconImageView.tintColor = ColorPalette.blue
        } else if card.factionCode == "gray" {
            baseViewCell.iconImageView.tintColor = ColorPalette.gray
        }
    }

    override func prepareForReuse() {
        baseViewCell.iconImageView.image = nil
        baseViewCell.titleLabel.text = nil
        baseViewCell.subtitleLabel.text = nil
        baseViewCell.accessoryLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
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
