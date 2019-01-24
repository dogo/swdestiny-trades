//
//  NewPersonView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import TextFieldEffects

final class NewPersonView: UIView {

    lazy var firstNameTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: .zero)
        textField.textColor = .black
        textField.autocapitalizationType = .sentences
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = L10n.firstName
        textField.placeholderColor = .darkGray
        textField.borderInactiveColor = .black
        textField.borderActiveColor = .black
        textField.delegate = self
        return textField
    }()

    var lastNameTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: .zero)
        textField.textColor = .black
        textField.autocapitalizationType = .sentences
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = L10n.lastName
        textField.placeholderColor = .darkGray
        textField.borderInactiveColor = .black
        textField.borderActiveColor = .black
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewPersonView: BaseViewConfiguration {

    // MARK: - <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(firstNameTextField)
        self.addSubview(lastNameTextField)
    }

    internal func setupConstraints() {
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.snp.topMargin)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.height.equalTo(60)
        }

        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(33)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.height.equalTo(60)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}

extension NewPersonView: UITextFieldDelegate {

    // MARK: - <UITextFieldDelegate>

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField == textField {
            lastNameTextField.becomeFirstResponder()
        }
        return true
    }
}
