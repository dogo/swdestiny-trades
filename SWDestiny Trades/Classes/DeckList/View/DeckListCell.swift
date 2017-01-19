//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable
import RealmSwift

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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "ic_edit"), for: .normal)
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
    }

    // MARK: - Actions

    func accessoryButtonTouched(sender : Any?) {
        titleEditText.isUserInteractionEnabled = !titleEditText.isUserInteractionEnabled
        if titleEditText.isUserInteractionEnabled {
            titleEditText.becomeFirstResponder()
        } else {
            let realm = try! Realm()
            try! realm.write {
                deckDTO?.name = titleEditText.text!
                realm.add(deckDTO!, update: true)
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
