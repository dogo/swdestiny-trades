//
//  DeckBuilderCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 28/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderCell: UITableViewCell, Identifiable {

    var stepperValueChanged: ((Int) -> Void)?
    var eliteButtonTouched: ((Bool) -> Void)?

    let textContainer: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        return view
    }()

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

    var eliteButton: ToggleButton = {
        let button = ToggleButton(frame: .zero)
        button.setTitle(L10n.nonElite, for: .normal)
        button.setTitleColor(.whiteBlack, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(card: CardDTO) {
        titleLabel.text = card.name
        setSubtitle(card: card)
        setIconImage(card: card)
        quantityLabel.text = String(card.quantity)
        quantityStepper.value = Double(card.quantity)
        quantityStepper.maximumValue = Double(card.deckLimit)
        quantityStepper.isHidden = (card.typeCode == "character" && card.isUnique) || card.typeCode == "battlefield"
        eliteButton.isHidden = !(card.typeCode == "character" && card.isUnique)
        eliteButton.isActivate = card.isElite
    }

    private func setSubtitle(card: CardDTO) {
        subtitleLabel.text = card.subtitle
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
        self.stepperValueChanged?(value)
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

extension DeckBuilderCell: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.contentView.addSubview(textContainer)
        self.contentView.addSubview(iconImageView)
        self.textContainer.addArrangedSubview(titleLabel)
        self.textContainer.addArrangedSubview(subtitleLabel)
        self.contentView.addSubview(quantityLabel)
        self.contentView.addSubview(quantityStepper)
        self.contentView.addSubview(eliteButton)
    }

    internal func setupConstraints() {
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

        textContainer.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor, constant: 8)
            view.leadingAnchor(equalTo: self.quantityLabel.trailingAnchor, constant: 8)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor, constant: -8)
        }

        quantityStepper.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
        }

        eliteButton.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
            view.widthAnchor(equalTo: self.quantityStepper.widthAnchor)
        }
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator

        eliteButton.buttonTouched = { [weak self] newVaue in
            self?.eliteButtonTouched?(newVaue)
        }
    }
}
