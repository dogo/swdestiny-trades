//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class DeckListCell: UITableViewCell, Reusable, BaseViewConfiguration, UITextFieldDelegate {

    private var deckDTO: DeckDTO?

    var titleEditText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textColor = .black
        textField.tintColor = .black
        textField.placeholder = L10n.deckName
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    var subTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var accessoryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(accessoryButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(deck: DeckDTO) {
        deckDTO = deck
        titleEditText.text = deckDTO?.name

        if let deckList = deckDTO?.list {
            let count = deckList.sum(ofProperty: "quantity") as Int
            if count > 0 { // swiftlint:disable:this empty_count // false postive
                subTitle.text = String.localizedStringWithFormat(NSLocalizedString("CARDS_COUNT", comment: ""), count)
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
        titleEditText.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(8)
            make.left.equalTo(self.contentView).offset(12)
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(titleEditText.snp.bottom)
            make.left.equalTo(self.contentView).offset(12)
            make.bottom.equalTo(self.contentView).offset(-8)
        }
        accessoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(titleEditText.snp.right)
            make.right.equalTo(self.contentView.snp.right)
        }
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
            try RealmManager.shared.realm.write {
                if let deck = deckDTO {
                    deck.name = titleEditText.text ?? ""
                    RealmManager.shared.realm.add(deck, update: true)
                }
            }
            } catch let error as NSError {
                print("Error opening realm: \(error)")
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
