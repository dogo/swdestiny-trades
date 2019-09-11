//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class DeckListCell: UITableViewCell, Reusable, BaseViewConfiguration, UITextFieldDelegate {

    private var deckDTO: DeckDTO?

    var titleEditText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.tintColor = .black
        textField.placeholder = L10n.deckName
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    var subTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleEditText.text = nil
        titleEditText.isUserInteractionEnabled = false
        toggleEditButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }

    // MARK: <BaseViewConfiguration>

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

    private func toggleEditButton() {
        let isEditing = titleEditText.isUserInteractionEnabled
        accessoryButton.setImage(isEditing ? Asset.icDoneEdit.image : Asset.icEdit.image, for: .normal)
    }

    // MARK: - Actions

    @objc
    func accessoryButtonTouched(sender: Any?) {
        titleEditText.isUserInteractionEnabled = !titleEditText.isUserInteractionEnabled
        toggleEditButton()
        if titleEditText.isUserInteractionEnabled {
            titleEditText.becomeFirstResponder()
        } else {
            do {
            try RealmManager.shared.realm.write { [weak self] in
                if let deck = self?.deckDTO {
                    deck.name = self?.titleEditText.text ?? ""
                    RealmManager.shared.realm.add(deck, update: .all)
                }
            }
            } catch let error as NSError {
                debugPrint("Error opening realm: \(error)")
            }
        }
    }

    // MARK: - <UITextFieldDelegate>

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleEditText == textField {
            accessoryButtonTouched(sender: nil)
        }
        return true
    }
}
