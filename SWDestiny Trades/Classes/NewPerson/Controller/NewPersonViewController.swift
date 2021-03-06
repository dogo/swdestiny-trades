//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class NewPersonViewController: UIViewController {
    private let newPersonView = NewPersonView()
    weak var delegate: UpdateTableDataDelegate?

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = newPersonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.newPerson
    }

    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched(_:)))
    }

    // MARK: - UIBarButton Actions

    @objc
    func doneButtonTouched(_ sender: Any) {
        let name = newPersonView.firstNameTextField.text ?? ""
        let lastName = newPersonView.lastNameTextField.text ?? ""

        if !name.isEmpty {
            let person = PersonDTO()
            person.name = name
            person.lastName = lastName
            delegate?.insertNew(person: person)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
