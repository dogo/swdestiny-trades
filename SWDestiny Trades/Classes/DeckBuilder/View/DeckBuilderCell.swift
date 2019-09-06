//
//  DeckBuilderCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 28/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class DeckBuilderCell: UITableViewCell, Reusable, BaseViewConfiguration {

    var stepperValueChanged: ((Int, DeckBuilderCell) -> Void)?
    var eliteButtonTouched: ((Bool, DeckBuilderCell) -> Void)?

    let textContainer: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    var iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749.0), for: .horizontal)
        return label
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    var quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        stepper.tintColor = ColorPalette.appTheme
        stepper.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return stepper
    }()

    var eliteButton: ToggleButton = {
        let button = ToggleButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.nonElite, for: .normal)
        button.setTitleColor(ColorPalette.appTheme, for: .normal)
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
        self.stepperValueChanged?(value, self)
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

    // MARK: <BaseViewConfiguration>

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
        iconImageView
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 8)
            .heightAnchor(equalTo: 25)
            .widthAnchor(equalTo: 25)

        quantityLabel
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.iconImageView.trailingAnchor, constant: 8)

        textContainer
            .topAnchor(equalTo: self.contentView.topAnchor, constant: 8)
            .leadingAnchor(equalTo: self.quantityLabel.trailingAnchor, constant: 8)
            .bottomAnchor(equalTo: self.contentView.bottomAnchor, constant: -8)

        quantityStepper
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)

        eliteButton
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)
            .widthAnchor(equalTo: self.quantityStepper.widthAnchor)
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator

        eliteButton.buttonTouched = { [weak self] newVaue in
            guard let self = self else { return }
            self.eliteButtonTouched?(newVaue, self)
        }
    }
}
