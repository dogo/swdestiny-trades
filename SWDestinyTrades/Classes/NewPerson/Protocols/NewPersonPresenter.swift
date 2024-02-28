//
//  NewPersonPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 27/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol NewPersonPresenterProtocol: AnyObject {
    func setNavigationTitle()
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void)
}

final class NewPersonPresenter: NewPersonPresenterProtocol {

    private weak var controller: NewPersonViewControllerProtocol?

    private weak var delegate: UpdateTableDataDelegate?

    init(controller: NewPersonViewControllerProtocol?,
         delegate: UpdateTableDataDelegate?) {
        self.controller = controller
        self.delegate = delegate
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.newPerson)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched(_:)))
        completion([doneButton])
    }

    // MARK: - UIBarButton Actions

    @objc
    private func doneButtonTouched(_ sender: Any) {
        let userInput = controller?.retriveUserInput()
        let name = userInput?.name ?? ""
        let lastName = userInput?.lastName ?? ""

        if !name.isEmpty {
            let person = PersonDTO()
            person.name = name
            person.lastName = lastName
            delegate?.insertNew(person: person)
        }
        controller?.closeViewController()
    }
}
