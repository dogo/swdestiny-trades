//
//  DeckBuilderCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 28/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class DeckBuilderCell: UITableViewCell, Reusable, BaseViewConfiguration {

    var iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        return image
    }()

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    var quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    var quantityStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.minimumValue = 1
        stepper.maximumValue = 2
        stepper.tintColor = ColorPalette.appTheme
        return stepper
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        quantityStepper.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(card: CardDTO) {
        titleLabel.text = card.name
        setSubtitle(card: card)
        setIconImage(card: card)
        quantityLabel.text = String(card.quantity)
    }

    private func setSubtitle(card: CardDTO) {

        subtitleLabel.text = card.subtitle

        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(quantityLabel.snp.right).offset(8)
            guard let subtitle = subtitleLabel.text, subtitle.isNotEmpty else {
                make.centerY.equalTo(self.contentView)
                return
            }
            make.top.equalTo(self.contentView).offset(8)
        }
    }

    private func setIconImage(card: CardDTO) {
        let imageForRendering = UIImage(named: "ic_\(card.typeCode)")?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = imageForRendering

        if card.factionCode == "red" {
            iconImageView.tintColor = ColorPalette.red
        } else if card.factionCode == "yellow" {
            iconImageView.tintColor = ColorPalette.yellow
        } else if card.factionCode == "blue" {
            iconImageView.tintColor = ColorPalette.blue
        } else if card.factionCode == "gray" {
            iconImageView.tintColor = ColorPalette.gray
        }
    }

    func valueChanged(_ sender: UIStepper) {
        //self.delegate?.didSelectSegment(index: sender.selectedSegmentIndex)
        quantityLabel.text = String(Int(sender.value))
    }

    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        quantityLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        self.contentView.addSubview(quantityLabel)
        self.contentView.addSubview(quantityStepper)
    }

    internal func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(12)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }

        quantityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(iconImageView.snp.right).offset(8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(8)
            make.left.equalTo(quantityLabel.snp.right).offset(8)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(quantityLabel.snp.right).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
        }

        quantityStepper.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView.snp.right)
        }
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
