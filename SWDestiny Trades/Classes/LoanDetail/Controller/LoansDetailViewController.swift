//
//  LoansDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class LoansDetailViewController: UIViewController {

    fileprivate let loanDetailView = LoanDetailView()

    var personDTO: PersonDTO!

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = loanDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromRealm()

        self.loanDetailView.loanDetailTableView.didSelectCard = { [weak self] card, lentMe in
            self?.navigateToCardDetailViewController(with: card, lentMe: lentMe)
        }

        self.loanDetailView.loanDetailTableView.didSelectAddItem = { [weak self] lentMe in
            self?.navigateToAddCardViewController(lentMe: lentMe)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "\(personDTO.name) \(personDTO.lastName)"
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadDataFromRealm() {
        loanDetailView.loanDetailTableView.updateTableViewData(person: personDTO)
    }

    @objc private func reloadTableView(_ notification: NSNotification) {
        if let person = notification.userInfo?["personDTO"] as? PersonDTO {
            personDTO = person
            loadDataFromRealm()
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(with card: CardDTO, lentMe: Bool) {
        let source = lentMe ? personDTO.lentMe : personDTO.borrowed
        let nextController = CardDetailViewController(cardList: Array(source), selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToAddCardViewController(lentMe: Bool) {
        let nextController = AddCardViewController()
        nextController.isLentMe = lentMe
        nextController.personDTO = personDTO
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
