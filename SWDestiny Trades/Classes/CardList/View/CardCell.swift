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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
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
            if !card.subtitle.isEmpty {
                baseViewCell.subtitleLabel.text?.append(", \(card.subtitle)")
            }
        } else {
            baseViewCell.subtitleLabel.text = "\(card.subtitle)"
        }

        baseViewCell.titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(baseViewCell.iconImageView.snp.right).offset(12)
            guard let subtitle = baseViewCell.subtitleLabel.text, !subtitle.isEmpty else {
                make.centerY.equalTo(baseViewCell.contentView)
                return
            }
            make.top.equalTo(baseViewCell.contentView)
        }
    }

    private func setIconImage(card: CardDTO) {
        let imageForRendering = UIImage(named: "ic_\(card.typeCode)")?.withRenderingMode(.alwaysTemplate)
        baseViewCell.iconImageView.image = imageForRendering
        baseViewCell.iconImageView.tintColor = card.factionColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
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
