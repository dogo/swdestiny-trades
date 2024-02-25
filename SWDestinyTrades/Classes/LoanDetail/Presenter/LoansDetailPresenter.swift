//
//  LoansDetailPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol LoansDetailPresenterProtocol: AnyObject {
    func loadDataFromRealm()
    func setNavigationTitle()
    func navigateToCardDetail(with card: CardDTO, destination: AddCardType)
    func navigateToAddCard(type: AddCardType)
}

final class LoansDetailPresenter: LoansDetailPresenterProtocol {

    private let database: DatabaseProtocol?
    private var person: PersonDTO
    private let navigator: LoanDetailNavigator

    private weak var controller: LoansDetailViewControllerProtocol?

    init(controller: LoansDetailViewControllerProtocol?,
         database: DatabaseProtocol?,
         person: PersonDTO,
         navigator: LoanDetailNavigator) {
        self.controller = controller
        self.database = database
        self.person = person
        self.navigator = navigator

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NotificationKey.reloadTableViewNotification,
                                               object: nil)
    }

    func loadDataFromRealm() {
        controller?.updateTableViewData(person: person)
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle("\(person.name) \(person.lastName)")
    }

    func navigateToCardDetail(with card: CardDTO, destination: AddCardType) {
        let source = destination == .lent ? person.lentMe : person.borrowed
        navigator.navigate(to: .cardDetail(database: database, with: Array(source), card: card))
    }

    func navigateToAddCard(type: AddCardType) {
        navigator.navigate(to: .addCard(database: database, with: person, type: type))
    }

    // MARK: - UIBarButton Actions

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let personDTO = notification.userInfo?["personDTO"] as? PersonDTO {
            person = personDTO
            loadDataFromRealm()
        }
    }
}

extension LoansDetailPresenter: LoansDetailsProtocol {

    func stepperValueChanged(newValue: Int, card: CardDTO) {
        try? database?.update {
            card.quantity = newValue
        }
    }

    func remove(from section: AddCardType, at index: Int) {
        try? database?.update { [weak self] in
            switch section {
            case .lent:
                self?.person.lentMe.remove(at: index)
            case .borrow:
                self?.person.borrowed.remove(at: index)
            default:
                break
            }
        }
    }
}
