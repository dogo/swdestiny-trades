//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class DeckListCell: UITableViewCell, Reusable {

    private var deckDTO: DeckDTO?
    var accessoryButtonTouched: ((String, DeckDTO) -> Void)?

    var titleEditText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .secondaryLabel
        textField.attributedPlaceholder = NSAttributedString(string: L10n.deckName, attributes: [.foregroundColor: UIColor.secondaryLabel])
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    var subTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var accessoryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(accessoryButtonTouched(sender:)), for: .touchUpInside)
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

    private func toggleEditButton() {
        let isEditing = titleEditText.isUserInteractionEnabled
        let image = isEditing ? Asset.icDoneEdit.image : Asset.icEdit.image
        accessoryButton.tintColor = .whiteBlack
        accessoryButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    internal func configureCell(deck: DeckDTO) {
        deckDTO = deck
        titleEditText.text = deckDTO?.name

        if let deckList = deckDTO?.list {
            let quantity = deckList.sum(ofProperty: "quantity") as Int
            if quantity > 0 {
                subTitle.text = String.localizedStringWithFormat(NSLocalizedString("CARDS_COUNT", comment: ""), quantity)
            } else {
                subTitle.text = String.localizedStringWithFormat(NSLocalizedString("CARDS_COUNT", comment: ""), 0)
            }
        }
    }

    // MARK: - Actions

    @objc
    func accessoryButtonTouched(sender: Any?) {
        titleEditText.isUserInteractionEnabled = !titleEditText.isUserInteractionEnabled
        toggleEditButton()
        if titleEditText.isUserInteractionEnabled {
            titleEditText.becomeFirstResponder()
        } else if let deck = self.deckDTO {
            self.accessoryButtonTouched?(self.titleEditText.text ?? "", deck)
        }
    }
}

extension DeckListCell: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.contentView.addSubview(titleEditText)
        self.contentView.addSubview(subTitle)
        self.contentView.addSubview(accessoryButton)
    }

    internal func setupConstraints() {
        titleEditText
            .topAnchor(equalTo: self.contentView.topAnchor, constant: 8)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)

        subTitle
            .topAnchor(equalTo: self.titleEditText.bottomAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            .bottomAnchor(equalTo: self.contentView.bottomAnchor, constant: -8)

        accessoryButton
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.titleEditText.trailingAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)
            .widthAnchor(equalTo: 50)
            .heightAnchor(equalTo: 50)
    }

    internal func configureViews() {
        titleEditText.delegate = self
        toggleEditButton()
    }
}

extension DeckListCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleEditText === textField {
            accessoryButtonTouched(sender: nil)
        }
        return true
    }
}
