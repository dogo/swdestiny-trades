//
//  DeckListViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListViewController: UIViewController {

    fileprivate let deckListView = DeckListView()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = deckListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        loadDataFromRealm()

        deckListView.deckListTableView.didSelectDeck = { [unowned self] deck in
            self.navigateToNextController(with: deck)
        }
    }

    func loadDataFromRealm() {
        let decks = Array(RealmManager.shared.realm.objects(DeckDTO.self))
        deckListView.deckListTableView.updateTableViewData(decksList: decks)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.decks
        deckListView.deckListTableView.reloadData()
    }

    private func setupNavigationItem() {
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_account"), style: .plain, target: self, action: #selector(loginButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(_:)))
    }

    // MARK: - Navigation

    func navigateToNextController(with deck: DeckDTO) {
        let nextController = DeckBuilderViewController(with: deck)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    // MARK: - UIBarButton Actions

    func loginButtonTouched(_ sender: Any) {

    }

    @objc func addButtonTouched(_ sender: Any) {
        deckListView.deckListTableView.insert(deck: DeckDTO())
    }
}
