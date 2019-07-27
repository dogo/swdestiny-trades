//
//  AddToDeckViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import PKHUD
import Moya

final class AddToDeckViewController: UIViewController {

    private let destinyService = SWDestinyServiceImpl()
    private var cancellableService: Cancellable?
    private let addToDeckView = AddToDeckView()
    private var cards = [CardDTO]()
    private var deckDTO: DeckDTO?
    private lazy var navigator = AddCardNavigator(self.navigationController)

    // MARK: - Life Cycle

    convenience init(deck: DeckDTO?) {
        self.init(nibName: nil, bundle: nil)
        deckDTO = deck
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        cancellableService = destinyService.retrieveAllCards { [weak self] result in
            switch result {
            case .success(let allCards):
                self?.addToDeckView.addToDeckTableView.updateSearchList(allCards)
                self?.addToDeckView.activityIndicator.stopAnimating()
                self?.cards = allCards
            case .failure(let error as NSError):
                self?.addToDeckView.activityIndicator.stopAnimating()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                if error.code != 6 {
                    ToastMessages.showNetworkErrorMessage()
                    LoggerManager.shared.log(event: .allCards, parameters: ["error": errorMessage])
                }
            }
        }
    }

    private func loadDataFromRealm() {
        cancellableService?.cancel()
        if let collection = Array(RealmManager.shared.realm.objects(UserCollectionDTO.self)).first {
            self.cards = Array(collection.myCollection)
            addToDeckView.addToDeckTableView.updateSearchList(self.cards)
        }
    }

    // MARK: - Helpers

    private func insert(card: CardDTO) {
        let predicate = NSPredicate(format: "code == %@", card.code)
        do {
            try RealmManager.shared.realm.write { [weak self] in
                let copy = CardDTO(value: card)
                copy.id = NSUUID().uuidString
                copy.quantity = 1
                self?.insertToDeckBuilder(card: copy, predicate: predicate)
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    private func insertToDeckBuilder(card: CardDTO, predicate: NSPredicate) {
        if let deck = deckDTO, deck.list.filter(predicate).isEmpty {
            deck.list.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(deck, update: .all)
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

    // MARK: - Navigation

    func navigateToNextController(with card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(with: cards, card: card))
    }
}
