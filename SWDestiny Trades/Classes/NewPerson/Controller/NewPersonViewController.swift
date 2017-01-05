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

    fileprivate var newPersonView = NewPersonView()
    var delegate: PeopleListViewDelegate?

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
        self.navigationItem.title = "New Person"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTouched(_:))),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTouched(_:)))
        ]
    }

    // MARK: - UIBarButton Actions

    func cancelButtonTouched(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    func doneButtonTouched(_ sender: Any) {
//        if !firstNameTextField.text!.isEmpty {
//            let person = PersonDTO()
//            person.name = firstNameTextField.text!
//            person.lastName = lastNameTextField.text!
//            delegate?.insertNew(person: person)
//        }
        dismiss(animated: true, completion: nil)
    }
}
