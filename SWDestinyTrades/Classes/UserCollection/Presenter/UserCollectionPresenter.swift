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

    enum SortType {
        case alphabetical
        case number
        case color
    }

    private weak var controller: UserCollectionViewControllerProtocol?
    private let dispatchQueue: DispatchQueueType
    private let database: DatabaseProtocol?
    private let navigator: UserCollectionNavigator
    private var currentSortIndex: SortType = .alphabetical

    init(controller: UserCollectionViewControllerProtocol,
         dispatchQueue: DispatchQueueType = DispatchQueue.main,
         database: DatabaseProtocol?,
         navigator: UserCollectionNavigator) {
        self.controller = controller
        self.dispatchQueue = dispatchQueue
        self.database = database
        self.navigator = navigator
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.myCollection)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?, [UIBarButtonItem]?) -> Void) {
        let shareAction = UIAction { [weak self] action in
            if let barButtonItem = action.sender as? UIBarButtonItem {
                self?.share(barButtonItem)
            }
        }

        let shareBarItem = UIBarButtonItem(systemItem: .action, primaryAction: shareAction)

        let addCardAction = UIAction { [weak self] _ in
            self?.navigateToAddCard()
        }

        let addCardBarItem = UIBarButtonItem(systemItem: .add, primaryAction: addCardAction)

        let rightBarButtonItems = [addCardBarItem, shareBarItem]

        let sortAZAction = UIAction(title: L10n.aToZ) { [weak self] _ in
            self?.controller?.sort(.alphabetical)
            self?.currentSortIndex = .alphabetical
        }

        let sortCardNumberAction = UIAction(title: L10n.cardNumber) { [weak self] _ in
            self?.controller?.sort(.number)
            self?.currentSortIndex = .number
        }

        let sortColorAction = UIAction(title: L10n.color) { [weak self] _ in
            self?.controller?.sort(.color)
            self?.currentSortIndex = .color
        }

        let sortMenu = UIMenu(children: [sortAZAction, sortCardNumberAction, sortColorAction])
        let leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icSort.image, menu: sortMenu)

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

    func navigateToAddCard() {
        navigator.navigate(to: .addCard(database: database, with: getUserCollection()))
    }

    private func createDatabase(object: UserCollectionDTO) {
        try? database?.save(object: object, completion: nil)
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
