//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class NewPersonViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var delegate: PeopleListViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
    }

    // MARK: - IBActions

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        if !firstNameTextField.text!.isEmpty {
            let person = PersonDTO()
            person.name = firstNameTextField.text!
            person.lastName = lastNameTextField.text!
            delegate?.insertNew(person: person)
        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField == textField {
            lastNameTextField.becomeFirstResponder()
        }
        return true
    }
}
