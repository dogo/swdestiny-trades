//
//  AddToDeckViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import PKHUD

final class AddToDeckViewController: UIViewController {

    private let destinyService: SWDestinyServiceProtocol
    private let addToDeckView = AddToDeckView()
    private let database: DatabaseProtocol?
    private var cards = [CardDTO]()
    private var deckDTO: DeckDTO?
    private lazy var navigator = AddCardNavigator(self.navigationController)

    // MARK: - Life Cycle

    required init(service: SWDestinyServiceProtocol = SWDestinyService(), database: DatabaseProtocol?, deck: DeckDTO?) {
        self.destinyService = service
        self.database = database
        self.deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = addToDeckView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveAllCards()

        addToDeckView.addToDeckTableView.didSelectCard = { [weak self] card in
            self?.insert(card: card)
        }

        addToDeckView.addToDeckTableView.didSelectAccessory = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        addToDeckView.searchBar.doingSearch = { [weak self] query in
            self?.addToDeckView.addToDeckTableView.doingSearch(query)
        }

        addToDeckView.addToDeckTableView.didSelectRemote = { [weak self] in
            self?.retrieveAllCards()
        }

        addToDeckView.addToDeckTableView.didSelectLocal = { [weak self] in
            self?.loadDataFromRealm()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.addCard
    }

    private func retrieveAllCards() {
        addToDeckView.activityIndicator.startAnimating()
        destinyService.retrieveAllCards { [weak self] result in
            self?.addToDeckView.activityIndicator.stopAnimating()
            switch result {
            case .success(let allCards):
                self?.addToDeckView.addToDeckTableView.updateSearchList(allCards)
                self?.cards = allCards
            case .failure(let error):
                self?.handleFailure(error)
            }
        }
    }

    private func loadDataFromRealm() {
        destinyService.cancelAllRequests()
        try? self.database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] collections in
            guard let self = self, let collection = collections.first else { return }
            self.cards = Array(collection.myCollection)
            addToDeckView.addToDeckTableView.updateSearchList(self.cards)
        }
    }

    // MARK: - Helpers

    private func insert(card: CardDTO) {
        let copy = CardDTO(value: card)
        copy.id = NSUUID().uuidString
        copy.quantity = 1

        self.insertToDeckBuilder(card: copy)
    }

    private func insertToDeckBuilder(card: CardDTO) {
        if let deck = deckDTO, !deck.list.contains(where: { $0.code == card.code }) {
            try? self.database?.update { [weak self] in
                deck.list.append(card)
                self?.showSuccessMessage(card: card)
            }
            let deckDataDict: [String: DeckDTO] = ["deckDTO": deck]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: L10n.added, subtitle: card.name), delay: 0.2)
    }

    private func handleFailure(_ error: APIError) {
        switch error {
        case .requestCancelled:
            break
        default:
            ToastMessages.showNetworkErrorMessage()
            LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
        }
    }

    // MARK: - Navigation

    func navigateToNextController(with card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(database: self.database, with: cards, card: card))
    }
}
