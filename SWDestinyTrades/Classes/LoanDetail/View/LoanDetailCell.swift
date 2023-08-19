//
//  LoanDetailCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailCell: UITableViewCell, Identifiable {
    var stepperValueChanged: ((Int) -> Void)?

    var iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        return image
    }()

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749.0), for: .horizontal)
        return label
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    var quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.minimumValue = 1
        stepper.tintColor = ColorPalette.appTheme
        stepper.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return stepper
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(cardDTO: CardDTO) {
        titleLabel.text = cardDTO.name
        setIconImage(card: cardDTO)
        subtitleLabel.text = cardDTO.setName
        quantityLabel.text = String(cardDTO.quantity)
        quantityStepper.value = Double(cardDTO.quantity)
    }

    private func setIconImage(card: CardDTO) {
        let imageForRendering = UIImage(named: "ic_\(card.typeCode)")?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = imageForRendering
        iconImageView.tintColor = card.factionColor()
    }

    @objc
    func valueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        quantityLabel.text = String(value)
        stepperValueChanged?(value)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        quantityLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }
}

extension LoanDetailCell: BaseViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityStepper)
    }

    func setupConstraints() {
        iconImageView.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 8)
            view.heightAnchor(equalToConstant: 25)
            view.widthAnchor(equalToConstant: 25)
        }

        quantityLabel.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.iconImageView.trailingAnchor, constant: 8)
        }

        titleLabel.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor, constant: 8)
            view.trailingAnchor(equalTo: self.quantityStepper.leadingAnchor, constant: -1)
            view.leadingAnchor(equalTo: self.quantityLabel.trailingAnchor, constant: 8)
        }

        subtitleLabel.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.titleLabel.bottomAnchor)
            view.leadingAnchor(equalTo: self.quantityLabel.trailingAnchor, constant: 8)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor, constant: -8)
        }

        quantityStepper.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
        }
    }

    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}
