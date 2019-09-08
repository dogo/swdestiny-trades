//
//  AddCardViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import PKHUD

public enum AddCardType {
    case lent
    case borrow
    case collection
}

final class AddCardViewController: UIViewController {

    private let addCardView = AddCardView()
    private let destinyService: SWDestinyService
    private let addCardType: AddCardType
    private var cards = [CardDTO]()
    private var personDTO: PersonDTO?
    private var userCollectionDTO: UserCollectionDTO?
    private lazy var navigator = AddCardNavigator(self.navigationController)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(service: SWDestinyService = SWDestinyServiceImpl(),
         database: DatabaseProtocol?,
         person: PersonDTO? = nil,
         userCollection: UserCollectionDTO? = nil,
         type: AddCardType) {
        self.destinyService = service
        self.database = database
        self.addCardType = type
        super.init(nibName: nil, bundle: nil)
        self.personDTO = person
        userCollectionDTO = userCollection
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = addCardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addCardView.activityIndicator.startAnimating()
        destinyService.retrieveAllCards { [weak self] result in
            self?.addCardView.activityIndicator.stopAnimating()
            switch result {
            case .success(let allCards):
                guard let allCards = allCards else { return }
                self?.addCardView.addCardTableView.updateSearchList(allCards)
                self?.cards = allCards
            case .failure(let error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
            }
        }

        addCardView.addCardTableView.didSelectCard = { [weak self] card in
            self?.insert(card: card)
        }

        addCardView.addCardTableView.didSelectAccessory = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        addCardView.searchBar.doingSearch = { [weak self] query in
            self?.addCardView.addCardTableView.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.addCard
    }

    // MARK: - Helpers

    private func insert(card: CardDTO) {
        switch self.addCardType {
        case .lent:
            self.insertToLentMe(card: card)
        case .borrow:
            self.insertToBorrowed(card: card)
        case .collection:
            self.insertToCollection(card: card)
        }
    }

    private func insertToBorrowed(card: CardDTO) {
        if let person = personDTO, !person.borrowed.contains(where: { $0.code == card.code }) {
            try? self.database?.update { [weak self] in
                person.borrowed.append(card)
                self?.showSuccessMessage(card: card)
            }
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    private func insertToLentMe(card: CardDTO) {
        if let person = personDTO, !person.lentMe.contains(where: { $0.code == card.code }) {
            try? self.database?.update { [weak self] in
                person.lentMe.append(card)
                self?.showSuccessMessage(card: card)
            }
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    private func insertToCollection(card: CardDTO) {
        if let userCollection = userCollectionDTO, !userCollection.myCollection.contains(where: { $0.code == card.code }) {
            try? self.database?.update { [weak self] in
                userCollection.myCollection.append(card)
                self?.showSuccessMessage(card: card)
            }
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: L10n.added, subtitle: card.name), delay: 0.2)
    }

    // MARK: - Navigation

    func navigateToNextController(with card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(database: self.database, with: cards, card: card))
    }
}
