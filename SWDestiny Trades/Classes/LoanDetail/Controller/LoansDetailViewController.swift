//
//  LoansDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol LoansDetailViewDelegate: class {
    func didSelectItem(at: IndexPath)
}

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

        navigationItem.title = "\(personDTO.name) \(personDTO.lastName)"

        loadDataFromRealm()

        self.loanDetailView.loanDetailTableView.didSelectCard = { [weak self] card in
            self?.navigateToCardDetailViewController(with: card)
        }

        self.loanDetailView.loanDetailTableView.didSelectAddItem = { [weak self] lentMe in
            self?.navigateToAddCardViewController(lentMe: lentMe)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(LoansDetailViewController.reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = loanDetailView.loanDetailTableView.indexPathForSelectedRow {
            loanDetailView.loanDetailTableView.deselectRow(at: path, animated: animated)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadDataFromRealm() {
        loanDetailView.loanDetailTableView.updateTableViewData(borrowedList: Array(personDTO.borrowed), lentMeList: Array(personDTO.lentMe))
    }

    @objc private func reloadTableView(_ notification: NSNotification) {
        if let person = notification.userInfo?["personDTO"] as? PersonDTO {
            personDTO = person
            loadDataFromRealm()
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToAddCardViewController(lentMe: Bool) {
        let nextController = AddCardViewController()
        nextController.isLentMe = lentMe
        nextController.personDTO = personDTO
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
