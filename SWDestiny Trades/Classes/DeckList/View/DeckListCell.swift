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
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
    }()

    var accessoryButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return button
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(deck: DeckDTO) {
        deckDTO = deck
        titleEditText.text = deckDTO?.name
        accessoryButton.addTarget(self, action: #selector(accessoryButtonTouched(sender:)), for: .touchUpInside)
    }

    override func prepareForReuse() {
        titleEditText.text = nil
        titleEditText.isUserInteractionEnabled = false
        toggleEditButton()
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(titleEditText)
    }

    internal func setupConstraints() {
        titleEditText.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
        }
    }

    internal func configureViews() {
        self.accessoryView = accessoryButton
        titleEditText.delegate = self
        toggleEditButton()
    }
    
    private func toggleEditButton() {
        let isEditing = titleEditText.isUserInteractionEnabled
        accessoryButton.setImage(UIImage(named: isEditing ? "ic_done_edit" : "ic_edit"), for: .normal)
    }

    // MARK: - Actions

    func accessoryButtonTouched(sender : Any?) {
        titleEditText.isUserInteractionEnabled = !titleEditText.isUserInteractionEnabled
        toggleEditButton()
        if titleEditText.isUserInteractionEnabled {
            titleEditText.becomeFirstResponder()
        } else {
            try! RealmManager.shared.realm.write {
                deckDTO?.name = titleEditText.text!
                RealmManager.shared.realm.add(deckDTO!, update: true)
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
