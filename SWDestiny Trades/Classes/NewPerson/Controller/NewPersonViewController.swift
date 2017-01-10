//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

class NewPersonViewController: UIViewController {

    fileprivate let newPersonView = NewPersonView()
    var delegate: UpdateTableDataDelegate?

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = newPersonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("NEW_PERSON", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched(_:)))
    }

    // MARK: - UIBarButton Actions

    func doneButtonTouched(_ sender: Any) {
        if !newPersonView.firstNameTextField.text!.isEmpty {
            let person = PersonDTO()
            person.name = newPersonView.firstNameTextField.text!
            person.lastName = newPersonView.lastNameTextField.text!
            delegate?.insertNew(person: person)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}
