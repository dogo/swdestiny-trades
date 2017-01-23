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
    var isLentMe: Bool!
    var personDTO: PersonDTO!
    var deckDTO: DeckDTO!
    var isDeckBuilder = false

    // MARK: - Life Cycle

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
        }) { (error: DataResponse<Any>) in
            self.addCardView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            FIRAnalytics.logEvent(withName: "[Error] retrieveAllCards", parameters: ["error": failureReason as NSObject])
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
        if self.isDeckBuilder {
            self.insertToDeckBuilder(card: card)
        } else {
            self.insertToLoan(card: card)
        }
    }

    private func insertToLoan(card: CardDTO) {
        try! RealmManager.shared.realm.write {
            if isLentMe! {
                personDTO.lentMe.append(card)
            } else {
                personDTO.borrowed.append(card)
            }
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(personDTO, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": personDTO]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        }
    }

    private func insertToDeckBuilder(card: CardDTO) {
        try! RealmManager.shared.realm.write {
            deckDTO.list.append(card)
            showSuccessMessage(card: card)
            RealmManager.shared.realm.add(deckDTO, update: true)
            let deckDataDict: [String: DeckDTO] = ["deckDTO": deckDTO]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        HUD.flash(.labeledSuccess(title: NSLocalizedString("ADDED", comment: ""), subtitle: card.name), delay: 0.2)
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}