//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class NewPersonViewController: UIViewController {

    fileprivate let newPersonView = NewPersonView()
    weak var delegate: UpdateTableDataDelegate?

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.newPerson
    }

    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched(_:)))
    }

    // MARK: - UIBarButton Actions

    @objc
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
