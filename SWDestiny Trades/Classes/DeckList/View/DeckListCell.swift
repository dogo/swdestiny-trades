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

    var accessoryButton: UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()

    var highlightBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorPalette.lightLightGray
        return view
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
        if let count = deckDTO?.list.count {
            subTitle.text = String.localizedStringWithFormat(NSLocalizedString("CARDS_COUNT", comment: ""), count)
        } else {
            subTitle.text = String.localizedStringWithFormat(NSLocalizedString("CARDS_COUNT", comment: ""), 0)
        }
        accessoryButton.addTarget(self, action: #selector(accessoryButtonTouched(sender:)), for: .touchUpInside)
    }

    override func prepareForReuse() {
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
        self.selectedBackgroundView = highlightBackgroundView
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
