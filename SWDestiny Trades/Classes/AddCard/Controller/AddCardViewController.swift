//
//  AddCardViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import FirebaseAnalytics

class AddCardViewController: UIViewController {

    fileprivate let addCardView = AddCardView()
    fileprivate var cards = [CardDTO]()
    fileprivate var personDTO: PersonDTO?
    fileprivate var deckDTO: DeckDTO?
    fileprivate var userCollectionDTO: UserCollectionDTO?
    fileprivate var isDeckBuilder = false
    fileprivate var isLentMe = false
    fileprivate var isUserCollection = false

    // MARK: - Life Cycle

    convenience init(deck: DeckDTO?, isDeckBuilder deckBuilder: Bool) {
        self.init(nibName: nil, bundle: nil)
        deckDTO = deck
        isDeckBuilder = deckBuilder
    }

    convenience init(person: PersonDTO?, isLentMe lentMe: Bool) {
        self.init(nibName: nil, bundle: nil)
        personDTO = person
        isLentMe = lentMe
    }

    convenience init(userCollection: UserCollectionDTO?, isUserCollection collection: Bool) {
        self.init(nibName: nil, bundle: nil)
        userCollectionDTO = userCollection
        isUserCollection = collection
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = addCardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addCardView.activityIndicator.startAnimating()
        SWDestinyAPI.retrieveAllCards(successBlock: { (cardsArray: [CardDTO]) in
            self.addCardView.activityIndicator.stopAnimating()
            self.addCardView.addCardTableView.updateSearchList(cardsArray)
            self.cards = cardsArray
        }) { (error: DataResponse<Any>) in
            self.addCardView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            Analytics.logEvent("retrieveAllCards", parameters: ["error": failureReason as NSObject])
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
        self.navigationItem.title = NSLocalizedString("ADD_CARD", comment: "")
    }

    // MARK: - Helpers
    private func insert(card: CardDTO) {
        let predicate = NSPredicate(format: "code == %@", card.code)
        do {
            try RealmManager.shared.realm.write {
                if self.isDeckBuilder {
                    self.insertToDeckBuilder(card: card, predicate: predicate)
                } else if self.isUserCollection {
                    self.insertToCollection(card: card, predicate: predicate)
                } else if self.isLentMe {
                    self.insertToLentMe(card: card, predicate: predicate)
                } else {
                    self.insertToBorrowed(card: card, predicate: predicate)
                }
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    private func insertToBorrowed(card: CardDTO, predicate: NSPredicate) {
        if let exist = personDTO?.borrowed.filter(predicate), exist.count == 0 {
            personDTO?.borrowed.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(personDTO!, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": personDTO!]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: NSLocalizedString("ALREADY_ADDED", comment: ""))
        }
    }

    private func insertToLentMe(card: CardDTO, predicate: NSPredicate) {
        if let exist = personDTO?.lentMe.filter(predicate), exist.count == 0 {
            personDTO?.lentMe.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(personDTO!, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": personDTO!]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: NSLocalizedString("ALREADY_ADDED", comment: ""))
        }
    }

    private func insertToDeckBuilder(card: CardDTO, predicate: NSPredicate) {
        if let exist = deckDTO?.list.filter(predicate), exist.count == 0 {
            deckDTO?.list.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(deckDTO!, update: true)
            let deckDataDict: [String: DeckDTO] = ["deckDTO": deckDTO!]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: NSLocalizedString("ALREADY_ADDED", comment: ""))
        }
    }

    private func insertToCollection(card: CardDTO, predicate: NSPredicate) {
        if let exist = userCollectionDTO?.myCollection.filter(predicate), exist.count == 0 {
            userCollectionDTO?.myCollection.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(userCollectionDTO!, update: true)
        } else {
            ToastMessages.showInfoMessage(title: "", message: NSLocalizedString("ALREADY_ADDED", comment: ""))
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: NSLocalizedString("ADDED", comment: ""), subtitle: card.name), delay: 0.2)
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cards, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
