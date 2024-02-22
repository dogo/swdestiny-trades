//
//  DeckListViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListViewController: UIViewController {

    private let deckListView: DeckListViewType

    var presenter: DeckListPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: DeckListViewType) {
        deckListView = view
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

        presenter?.setupNavigationItems { [weak self] items in
            self?.navigationItem.rightBarButtonItems = items
        }

        presenter?.loadDataFromRealm()

        deckListView.didSelectDeck = { [weak self] deck in
            self?.presenter?.navigateToDeckBuilder(with: deck)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()

        deckListView.refreshData()
    }
}

extension DeckListViewController: DeckListViewControllerProtocol {

    func updateTableViewData(deckList: [DeckDTO]) {
        deckListView.updateTableViewData(decksList: deckList)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}
