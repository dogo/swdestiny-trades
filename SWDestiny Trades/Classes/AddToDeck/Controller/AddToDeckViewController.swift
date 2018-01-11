//
//  AddToDeckViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseAnalytics

class AddToDeckViewController: UIViewController {

    fileprivate let destinyService = SWDestinyServiceImpl()
    fileprivate let addToDeckView = AddToDeckView()
    fileprivate var cards = [CardDTO]()
    fileprivate var deckDTO: DeckDTO?

    // MARK: - Life Cycle

    convenience init(deck: DeckDTO?) {
        self.init(nibName: nil, bundle: nil)
        deckDTO = deck
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = addToDeckView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveAllCards()

        addToDeckView.addToDeckTableView.didSelectCard = { [unowned self] card in
            self.insert(card: card)
        }

        addToDeckView.addToDeckTableView.didSelectAccessory = { [unowned self] card in
            self.navigateToNextController(with: card)
        }

        addToDeckView.searchBar.doingSearch = { [unowned self] query in
            self.addToDeckView.addToDeckTableView.doingSearch(query)
        }

        addToDeckView.addToDeckTableView.didSelectRemote = { [unowned self] in
            self.retrieveAllCards()
        }

        addToDeckView.addToDeckTableView.didSelectLocal = { [unowned self] in
            self.loadDataFromRealm()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.addCard
    }

    fileprivate func retrieveAllCards() {
        addToDeckView.activityIndicator.startAnimating()
        destinyService.retrieveAllCards { result in
            switch result {
            case .success(let allCards):
                self.addToDeckView.addToDeckTableView.updateSearchList(allCards)
                self.addToDeckView.activityIndicator.stopAnimating()
                self.cards = allCards
            case .failure(let error):
                self.addToDeckView.activityIndicator.stopAnimating()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                Analytics.logEvent("retrieveAllCards", parameters: ["error": errorMessage])
            }
        }
    }

    fileprivate func loadDataFromRealm() {
        if let collection = Array(RealmManager.shared.realm.objects(UserCollectionDTO.self)).first {
            self.cards = Array(collection.myCollection)
            addToDeckView.addToDeckTableView.updateSearchList(self.cards)
        }
    }

    // MARK: - Helpers

    fileprivate func insert(card: CardDTO) {
        let predicate = NSPredicate(format: "code == %@", card.code)
        do {
            try RealmManager.shared.realm.write {
                let copy = CardDTO(value: card)
                copy.id = NSUUID().uuidString
                copy.quantity = 1
                self.insertToDeckBuilder(card: copy, predicate: predicate)
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    fileprivate func insertToDeckBuilder(card: CardDTO, predicate: NSPredicate) {
        if let deck = deckDTO, deck.list.filter(predicate).isEmpty {
            deck.list.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(deck, update: true)
            let deckDataDict: [String: DeckDTO] = ["deckDTO": deck]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    fileprivate func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: L10n.added, subtitle: card.name), delay: 0.2)
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cards, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
