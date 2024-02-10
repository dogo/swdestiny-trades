//
//  DeckBuilderPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 10/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckBuilderPresenterProtocol: AnyObject {
    func loadData(deck: DeckDTO?)
    func setNavigationTitle()
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void)
    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO)
}

final class DeckBuilderPresenter: DeckBuilderPresenterProtocol {

    private weak var controller: DeckBuilderViewControllerProtocol?
    private let dispatchQueue: DispatchQueueType
    private let database: DatabaseProtocol?
    private let navigator: DeckBuilderNavigator
    private let deckDTO: DeckDTO

    init(controller: DeckBuilderViewControllerProtocol,
         dispatchQueue: DispatchQueueType = DispatchQueue.main,
         database: DatabaseProtocol?,
         navigator: DeckBuilderNavigator,
         deckDTO: DeckDTO) {
        self.controller = controller
        self.dispatchQueue = dispatchQueue
        self.database = database
        self.navigator = navigator
        self.deckDTO = deckDTO
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)
    }

    func loadData(deck: DeckDTO?) {
        controller?.updateTableViewData(deck: deckDTO)
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(deckDTO.name)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddToDeckViewController))
        let deckGraphBarItem = UIBarButtonItem(image: Asset.NavigationBar.icChart.image, style: .plain, target: self, action: #selector(navigateToDeckGraphViewController))
        completion([addCardBarItem, deckGraphBarItem, shareBarItem])
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let deck = notification.userInfo?["deckDTO"] as? DeckDTO {
            loadData(deck: deck)
        }
    }

    @objc
    private func share(_ sender: UIBarButtonItem) {
        var deckList = "\(deckDTO.name)\n\n"

        if let deckObject = controller?.getDeckList() {
            for section in deckObject {
                deckList.append(String(format: "%@ (%d)\n", section.name, section.items.count))
                for card in section.items {
                    deckList.append(String(format: "%d %@\n", card.quantity, card.name))
                }
                deckList.append("\n")
            }
        }

        let activityVC = UIActivityViewController(activityItems: [SwdShareProvider(subject: deckDTO.name, text: deckList), L10n.shareText], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.saveToCameraRoll, .postToFlickr, .postToVimeo, .assignToContact, .addToReadingList, .postToFacebook]

        activityVC.popoverPresentationController?.barButtonItem = sender
        dispatchQueue.globalAsync { [weak self] in
            self?.dispatchQueue.async {
                self?.controller?.presentViewController(activityVC, animated: true)
            }
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }

    @objc
    private func navigateToAddToDeckViewController() {
        navigator.navigate(to: .addToDeck(database: database, with: deckDTO))
    }

    @objc
    private func navigateToDeckGraphViewController() {
        navigator.navigate(to: .deckGraph(with: deckDTO))
    }
}

extension DeckBuilderPresenter: DeckBuilderProtocol {

    func updateCardQuantity(newValue: Int, card: CardDTO) {
        try? database?.update {
            card.quantity = newValue
        }
    }

    func updateCharacterElite(newValue: Bool, card: CardDTO) {
        try? database?.update {
            card.isElite = newValue
        }
    }

    func remove(at index: Int) {
        try? database?.update { [weak self] in
            self?.deckDTO.list.remove(at: index)
        }
    }
}
