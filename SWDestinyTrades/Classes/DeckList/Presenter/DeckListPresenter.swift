//
//  DeckListPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckListPresenterProtocol: AnyObject {
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void)
    func setNavigationTitle()
    func loadDataFromRealm()
    func navigateToDeckBuilder(with deck: DeckDTO)
}

final class DeckListPresenter: DeckListPresenterProtocol {

    private let database: DatabaseProtocol?
    private let navigator: DeckListNavigator

    private weak var controller: DeckListViewControllerProtocol?

    init(controller: DeckListViewControllerProtocol?,
         database: DatabaseProtocol?,
         navigator: DeckListNavigator) {
        self.controller = controller
        self.database = database
        self.navigator = navigator
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(_:)))
        completion([addCardBarItem])
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.decks)
    }

    func loadDataFromRealm() {
        try? database?.fetch(DeckDTO.self, predicate: nil, sorted: nil) { [weak self] decks in
            self?.controller?.updateTableViewData(deckList: decks)
        }
    }

    func navigateToDeckBuilder(with deck: DeckDTO) {
        navigator.navigate(to: .deckBuilder(database: database, with: deck))
    }

    // MARK: - UIBarButton Actions

    @objc
    private func addButtonTouched(_ sender: Any) {
        insert(deck: DeckDTO())
    }
}

extension DeckListPresenter: DeckListProtocol {

    func insert(deck: DeckDTO) {
        try? database?.save(object: deck) { [weak self] in
            self?.loadDataFromRealm()
        }
    }

    func remove(deck: DeckDTO) {
        try? database?.delete(object: deck)
    }

    func rename(name: String, deck: DeckDTO) {
        try? database?.update {
            deck.name = name
        }
    }
}
