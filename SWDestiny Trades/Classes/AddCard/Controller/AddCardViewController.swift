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

class AddCardViewController: UIViewController {

    fileprivate let addCardView = AddCardView()
    fileprivate let destinyService: SWDestinyService
    fileprivate let addCardType: AddCardType
    fileprivate var cards = [CardDTO]()
    fileprivate var personDTO: PersonDTO?
    fileprivate var userCollectionDTO: UserCollectionDTO?
    fileprivate lazy var navigator = AddCardNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(service: SWDestinyService = SWDestinyServiceImpl(),
         person: PersonDTO? = nil,
         userCollection: UserCollectionDTO? = nil,
         type: AddCardType) {
        destinyService = service
        addCardType = type
        super.init(nibName: nil, bundle: nil)
        personDTO = person
        userCollectionDTO = userCollection
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
        destinyService.retrieveAllCards { result in
            switch result {
            case .success(let allCards):
                self.addCardView.addCardTableView.updateSearchList(allCards)
                self.addCardView.activityIndicator.stopAnimating()
                self.cards = allCards
            case .failure(let error):
                self.addCardView.activityIndicator.stopAnimating()
                ToastMessages.showNetworkErrorMessage()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                LoggerManager.shared.log(event: .allCards, parameters: ["error": errorMessage])
            }
        }

        addCardView.addCardTableView.didSelectCard = { [unowned self] card in
            self.insert(card: card)
        }

        addCardView.addCardTableView.didSelectAccessory = { [unowned self] card in
            self.navigateToNextController(with: card)
        }

        addCardView.searchBar.doingSearch = { [unowned self] query in
            self.addCardView.addCardTableView.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.addCard
    }

    // MARK: - Helpers

    fileprivate func insert(card: CardDTO) {
        let predicate = NSPredicate(format: "code == %@", card.code)
        do {
            try RealmManager.shared.realm.write {
                switch self.addCardType {
                case .lent:
                    self.insertToLentMe(card: card, predicate: predicate)
                case .borrow:
                    self.insertToBorrowed(card: card, predicate: predicate)
                case .collection:
                    self.insertToCollection(card: card, predicate: predicate)
                }
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    fileprivate func insertToBorrowed(card: CardDTO, predicate: NSPredicate) {
        if let person = personDTO, person.borrowed.filter(predicate).isEmpty {
            person.borrowed.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(person, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    fileprivate func insertToLentMe(card: CardDTO, predicate: NSPredicate) {
        if let person = personDTO, person.lentMe.filter(predicate).isEmpty {
            person.lentMe.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(person, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    fileprivate func insertToCollection(card: CardDTO, predicate: NSPredicate) {
        if let userCollection = userCollectionDTO, userCollection.myCollection.filter(predicate).isEmpty {
            userCollection.myCollection.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(userCollection, update: true)
        } else {
            ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
        }
    }

    fileprivate func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: L10n.added, subtitle: card.name), delay: 0.2)
    }

    // MARK: - Navigation

    func navigateToNextController(with card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(with: cards, card: card))
    }
}
