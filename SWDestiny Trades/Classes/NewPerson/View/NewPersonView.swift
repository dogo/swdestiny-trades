//
//  NewPersonView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import TextFieldEffects

final class NewPersonView: UIView, BaseViewConfiguration, UITextFieldDelegate {

    var firstNameTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: .zero)
        return textField
    }()

    var lastNameTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: .zero)
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(firstNameTextField)
        self.addSubview(lastNameTextField)
    }

    internal func setupConstraints() {
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(65+44+20)
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

        self.backgroundColor = UIColor.white

        firstNameTextField.textColor = UIColor.black
        firstNameTextField.autocapitalizationType = .sentences
        firstNameTextField.font = UIFont.systemFont(ofSize: 17)
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.placeholderColor = UIColor.darkGray
        firstNameTextField.borderInactiveColor = UIColor.black
        firstNameTextField.borderActiveColor = UIColor.black

        lastNameTextField.textColor = UIColor.black
        lastNameTextField.autocapitalizationType = .sentences
        lastNameTextField.font = UIFont.systemFont(ofSize: 17)
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.placeholderColor = UIColor.darkGray
        lastNameTextField.borderInactiveColor = UIColor.black
        lastNameTextField.borderActiveColor = UIColor.black

        firstNameTextField.delegate = self
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField == textField {
            lastNameTextField.becomeFirstResponder()
        }
        return true
    }
}
