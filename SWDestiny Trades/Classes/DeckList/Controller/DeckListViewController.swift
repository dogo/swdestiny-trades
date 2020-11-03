//
//  DeckListViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListViewController: UIViewController {
    private lazy var deckListView = DeckListTableView(delegate: self)
    private lazy var navigator = DeckListNavigator(self.navigationController)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = deckListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        loadDataFromRealm()

        deckListView.didSelectDeck = { [weak self] deck in
            self?.navigateToNextController(with: deck)
        }
    }

    func loadDataFromRealm() {
        try? database?.fetch(DeckDTO.self, predicate: nil, sorted: nil) { [weak self] decks in
            self?.deckListView.updateTableViewData(decksList: decks)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.decks
        deckListView.reloadData()
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(_:)))
    }

    // MARK: - Navigation

    func navigateToNextController(with deck: DeckDTO) {
        navigator.navigate(to: .deckBuilder(database: database, with: deck))
    }

    // MARK: - UIBarButton Actions

    @objc
    func addButtonTouched(_ sender: Any) {
        deckListView.insert(deck: DeckDTO())
    }
}

extension DeckListViewController: DeckListProtocol {
    func remove(deck: DeckDTO) {
        try? database?.delete(object: deck)
    }

    func insert(deck: DeckDTO) {
        try? database?.save(object: deck)
    }

    func rename(name: String, deck: DeckDTO) {
        try? database?.update {
            deck.name = name
        }
    }
}
