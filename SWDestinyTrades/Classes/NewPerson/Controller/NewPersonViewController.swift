//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class NewPersonViewController: UIViewController {

    private let newPersonView: NewPersonView

    var presenter: NewPersonPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: NewPersonView = NewPersonView()) {
        newPersonView = view
        super.init(nibName: nil, bundle: nil)
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

        presenter?.setupNavigationItems { [weak self] items in
            self?.navigationItem.rightBarButtonItems = items
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()
    }
}

extension NewPersonViewController: NewPersonViewControllerProtocol {

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func retriveUserInput() -> (name: String, lastName: String) {
        let name = newPersonView.firstNameTextField.nonOptionalText
        let lastName = newPersonView.lastNameTextField.nonOptionalText
        return (name, lastName)
    }

    func closeViewController() {
        navigationController?.popViewController(animated: true)
    }
}
