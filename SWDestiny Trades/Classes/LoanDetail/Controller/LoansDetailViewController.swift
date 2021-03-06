//
//  LoansDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoansDetailViewController: UIViewController {
    private let database: DatabaseProtocol?
    private var personDTO: PersonDTO
    private lazy var loanDetailView = LoanDetailTableView(delegate: self)
    private lazy var navigator = LoanDetailNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?, person: PersonDTO) {
        self.database = database
        personDTO = person
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loanDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromRealm()

        loanDetailView.didSelectCard = { [weak self] card, destination in
            self?.navigateToCardDetailViewController(with: card, destination: destination)
        }

        loanDetailView.didSelectAddItem = { [weak self] type in
            self?.navigateToAddCardViewController(type: type)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "\(personDTO.name) \(personDTO.lastName)"
    }

    func loadDataFromRealm() {
        loanDetailView.updateTableViewData(person: personDTO)
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let person = notification.userInfo?["personDTO"] as? PersonDTO {
            personDTO = person
            loadDataFromRealm()
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(with card: CardDTO, destination: AddCardType) {
        let source = destination == .lent ? personDTO.lentMe : personDTO.borrowed
        navigator.navigate(to: .cardDetail(database: database, with: Array(source), card: card))
    }

    func navigateToAddCardViewController(type: AddCardType) {
        navigator.navigate(to: .addCard(database: database, with: personDTO, type: type))
    }
}

extension LoansDetailViewController: LoansDetailsProtocol {
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        try? database?.update {
            card.quantity = newValue
        }
    }

    func remove(from section: AddCardType, at index: Int) {
        try? database?.update { [weak self] in
            switch section {
            case .lent:
                self?.personDTO.lentMe.remove(at: index)
            case .borrow:
                self?.personDTO.borrowed.remove(at: index)
            default:
                break
            }
        }
    }
}
