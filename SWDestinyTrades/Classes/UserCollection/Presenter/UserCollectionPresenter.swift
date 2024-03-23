//
//  UserCollectionPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol UserCollectionPresenterProtocol {
    func setNavigationTitle()
    func setupNavigationItems(completion: ([UIBarButtonItem]?, [UIBarButtonItem]?) -> Void)
    func loadDataFromRealm()
    func navigateToCardDetail(cardList: [CardDTO], card: CardDTO)
    func navigateToAddCard()
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {

    private weak var controller: UserCollectionViewControllerProtocol?
    private let dispatchQueue: DispatchQueueType
    private let database: DatabaseProtocol?
    private let navigator: UserCollectionNavigator
    private let manager: PopoverMenuManagerType
    private var currentSortIndex = 0

    init(controller: UserCollectionViewControllerProtocol,
         dispatchQueue: DispatchQueueType = DispatchQueue.main,
         manager: PopoverMenuManagerType = PopoverMenuManager(),
         database: DatabaseProtocol?,
         navigator: UserCollectionNavigator) {
        self.controller = controller
        self.dispatchQueue = dispatchQueue
        self.manager = manager
        self.database = database
        self.navigator = navigator
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.myCollection)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?, [UIBarButtonItem]?) -> Void) {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCard))

        let rightBarButtonItems = [addCardBarItem, shareBarItem]
        let leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icSort.image, style: .plain, target: self, action: #selector(sort(_:event:)))

        completion([leftBarButtonItem], rightBarButtonItems)
    }

    func loadDataFromRealm() {
        let user = getUserCollection()
        controller?.updateTableViewData(collection: user)
        controller?.sort(currentSortIndex)
    }

    func navigateToCardDetail(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }

    @objc
    func navigateToAddCard() {
        navigator.navigate(to: .addCard(database: database, with: getUserCollection()))
    }

    private func createDatabase(object: UserCollectionDTO) {
        try? database?.save(object: object)
    }

    private func getUserCollection() -> UserCollectionDTO {
        var user = UserCollectionDTO()
        try? database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] results in
            if let userCollection = results.first {
                user = userCollection
            } else {
                self?.createDatabase(object: user)
            }
        }
        return user
    }

    @objc
    private func share(_ sender: UIBarButtonItem) {
        var collectionList = ""

        if let cardList = controller?.getCardList() {
            for card in cardList {
                collectionList.append(String(format: "%d %@\n", card.quantity, card.name))
            }
        }

        let activityVC = UIActivityViewController(activityItems: [
            SwdShareProvider(subject: L10n.myCollection, text: collectionList),
            L10n.shareText
        ], applicationActivities: nil)

        activityVC.excludedActivityTypes = [
            .saveToCameraRoll,
            .postToFlickr,
            .postToVimeo,
            .assignToContact,
            .addToReadingList,
            .postToFacebook
        ]

        activityVC.popoverPresentationController?.barButtonItem = sender
        dispatchQueue.globalAsync { [weak self] in
            self?.dispatchQueue.async {
                self?.controller?.presentViewController(activityVC, animated: true)
            }
        }
    }

    @objc
    private func sort(_ sender: UIBarButtonItem, event: UIEvent) {
        manager.showPopoverMenu(forEvent: event,
                                with: [L10n.aToZ, L10n.cardNumber, L10n.color],
                                done: { [weak self] selectedIndex in
                                    self?.controller?.sort(selectedIndex)
                                    self?.currentSortIndex = selectedIndex
                                }, cancel: {})
    }
}

extension UserCollectionPresenter: UserCollectionProtocol {

    func stepperValueChanged(newValue: Int, card: CardDTO) {
        try? database?.update {
            card.quantity = newValue
        }
    }

    func remove(at index: Int) {
        try? database?.update { [weak self] in
            self?.getUserCollection().myCollection.remove(at: index)
        }
    }
}
