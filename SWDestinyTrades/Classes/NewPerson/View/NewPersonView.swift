//
//  NewPersonView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class NewPersonView: UIView, NewPersonViewType {

    private let firstNameTextField: FloatingTextfield = {
        let textField = FloatingTextfield(frame: .zero)
        textField.textColor = .whiteBlack
        textField.autocapitalizationType = .sentences
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = L10n.firstName
        textField.placeholderTextColor = .secondaryLabel
        return textField
    }()

    private let lastNameTextField: FloatingTextfield = {
        let textField = FloatingTextfield(frame: .zero)
        textField.textColor = .whiteBlack
        textField.autocapitalizationType = .sentences
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = L10n.lastName
        textField.placeholderTextColor = .secondaryLabel
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

    func retriveUserInput() -> (name: String, lastName: String) {
        let name = firstNameTextField.nonOptionalText
        let lastName = lastNameTextField.nonOptionalText
        return (name, lastName)
    }
}

extension NewPersonView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(firstNameTextField)
        addSubview(lastNameTextField)
    }

    func setupConstraints() {
        firstNameTextField.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor, constant: 12)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -12)
            view.heightAnchor(equalToConstant: 60)
        }

        lastNameTextField.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.firstNameTextField.bottomAnchor, constant: 33)
            view.leadingAnchor(equalTo: self.leadingAnchor, constant: 12)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -12)
            view.heightAnchor(equalToConstant: 60)
        }
    }

    func configureViews() {
        backgroundColor = .blackWhite
        firstNameTextField.delegate = self
    }
}

extension NewPersonView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField == textField {
            lastNameTextField.becomeFirstResponder()
        }
        return true
    }
}
