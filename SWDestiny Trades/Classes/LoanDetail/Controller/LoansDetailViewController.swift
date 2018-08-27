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
    fileprivate var personDTO: PersonDTO
    fileprivate var navigator: LoanDetailNavigator?

    // MARK: - Life Cycle

    init(person: PersonDTO) {
        self.personDTO = person
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = loanDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigator = LoanDetailNavigator(self.navigationController)

        loadDataFromRealm()

        self.loanDetailView.loanDetailTableView.didSelectCard = { [unowned self] card, lentMe in
            self.navigateToCardDetailViewController(with: card, lentMe: lentMe)
        }

        self.loanDetailView.loanDetailTableView.didSelectAddItem = { [unowned self] type in
            self.navigateToAddCardViewController(type: type)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)
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

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let person = notification.userInfo?["personDTO"] as? PersonDTO {
            personDTO = person
            loadDataFromRealm()
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(with card: CardDTO, lentMe: Bool) {
        let source = lentMe ? personDTO.lentMe : personDTO.borrowed
        self.navigator?.navigate(to: .cardDetail(with: Array(source), card: card))
    }

    func navigateToAddCardViewController(type: AddCardType) {
        self.navigator?.navigate(to: .addCard(with: personDTO, type: type))
    }
}
