//
//  AddCardViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

enum AddCardType {
    case lent
    case borrow
    case collection
}

final class AddCardViewController: UIViewController {

    private let addCardView: AddCardViewType
    private let destinyService: SWDestinyServiceProtocol
    private let addCardType: AddCardType
    private var cards = [CardDTO]()
    private var personDTO: PersonDTO?
    private var userCollectionDTO: UserCollectionDTO?
    private lazy var navigator = AddCardNavigator(self.navigationController)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(with view: AddCardViewType = AddCardView(),
         service: SWDestinyServiceProtocol = SWDestinyService(),
         database: DatabaseProtocol?,
         person: PersonDTO? = nil,
         userCollection: UserCollectionDTO? = nil,
         type: AddCardType) {
        addCardView = view
        destinyService = service
        self.database = database
        addCardType = type
        super.init(nibName: nil, bundle: nil)
        personDTO = person
        userCollectionDTO = userCollection
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = addCardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addCardView.startLoading()
        destinyService.retrieveAllCards { [weak self] result in
            self?.addCardView.stopLoading()
            switch result {
            case let .success(allCards):
                self?.addCardView.updateSearchList(allCards)
                self?.cards = allCards
            case let .failure(error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
            }
        }

        addCardView.didSelectCard = { [weak self] card in
            self?.insert(card: card)
        }

        addCardView.didSelectAccessory = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        addCardView.doingSearch = { [weak self] query in
            self?.addCardView.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.addCard
    }

    // MARK: - Helpers

    private func insert(card: CardDTO) {
        switch addCardType {
        case .lent:
            insertToLentMe(card: card)
        case .borrow:
            insertToBorrowed(card: card)
        case .collection:
            insertToCollection(card: card)
        }
    }

    private func insertToBorrowed(card: CardDTO) {
        if let person = personDTO, !person.borrowed.contains(where: { $0.code == card.code }) {
            try? database?.update { [weak self] in
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
            try? database?.update { [weak self] in
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
            try? database?.update { [weak self] in
                userCollection.myCollection.append(card)
                self?.showSuccessMessage(card: card)
            }
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        LoadingHUD.show(.labeledSuccess(title: L10n.added, subtitle: card.name))
    }

    // MARK: - Navigation

    func navigateToNextController(with card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cards, card: card))
    }
}
