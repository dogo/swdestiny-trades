//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListCell: UITableViewCell, Identifiable {

    private var deckDTO: DeckDTO?

    var editButtonTouched: ((String, DeckDTO) -> Void)?

    private let titleEditText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.tintColor = .secondaryLabel
        textField.attributedPlaceholder = NSAttributedString(string: L10n.deckName,
                                                             attributes: [.foregroundColor: UIColor.secondaryLabel])
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private let subTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let accessoryButton: UIButton = {
        let button = UIButton(frame: .zero)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleEditText.text = nil
        titleEditText.isUserInteractionEnabled = false
        toggleEditButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }

    func configureCell(deck: DeckDTO) {
        deckDTO = deck
        titleEditText.text = deck.name
        let quantity = deck.list.sum(ofProperty: "quantity") as Int
        subTitle.text = L10n.cardsCount(quantity)
    }

    private func toggleEditButton() {
        let isEditing = titleEditText.isUserInteractionEnabled
        let image = isEditing ? Asset.icDoneEdit.image : Asset.icEdit.image
        accessoryButton.tintColor = .whiteBlack
        accessoryButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    // MARK: - Actions

    @objc
    private func accessoryButtonTouched() {
        titleEditText.isUserInteractionEnabled.toggle()
        toggleEditButton()
        if titleEditText.isUserInteractionEnabled {
            titleEditText.becomeFirstResponder()
        } else if let deck = deckDTO {
            editButtonTouched?(titleEditText.text ?? "", deck)
        }
    }
}

extension DeckListCell: BaseViewConfiguration {

    func buildViewHierarchy() {
        contentView.addSubview(titleEditText)
        contentView.addSubview(subTitle)
        contentView.addSubview(accessoryButton)
    }

    func setupConstraints() {
        titleEditText.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor, constant: 8)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
        }

        subTitle.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.titleEditText.bottomAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor, constant: -8)
        }

        accessoryButton.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.titleEditText.trailingAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
            view.widthAnchor(equalToConstant: 50)
            view.heightAnchor(equalToConstant: 50)
        }
    }

    func configureViews() {
        titleEditText.delegate = self
        accessoryButton.addTarget(self, action: #selector(accessoryButtonTouched), for: .touchUpInside)
        toggleEditButton()
    }
}

extension DeckListCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleEditText === textField {
            accessoryButtonTouched()
        }
        return true
    }
}
