//
//  AddCardCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class AddCardCell: UITableViewCell, Reusable, BaseViewConfiguration {

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
        setIconImage(card: cardDTO)
        baseViewCell.subtitleLabel.text = "\(cardDTO.setName) -- \(cardDTO.rarityName)"
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
        baseViewCell.titleLabel.text = nil
        baseViewCell.subtitleLabel.text = nil
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
        self.accessoryType = .detailButton
        self.selectionStyle = .none
        self.tintColor = ColorPalette.appTheme
    }
}
