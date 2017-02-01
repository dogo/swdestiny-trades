//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderViewController: UIViewController {

    var deckDTO: DeckDTO!
    fileprivate let deckBuilderView = DeckBuilderView()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = deckBuilderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCardViewController))

        loadData(deck: deckDTO)

        deckBuilderView.deckBuilderTableView.didSelectCard = { [weak self] card in
            self?.navigateToCardDetailViewController(with: card)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = deckDTO.name
    }

    func loadData(deck: DeckDTO) {
        deckBuilderView.deckBuilderTableView.updateTableViewData(deck: deck)
    }

    @objc private func reloadTableView(_ notification: NSNotification) {
        if let deck = notification.userInfo?["deckDTO"] as? DeckDTO {
            loadData(deck: deck)
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(with card: CardDTO) {
        let nextController = CardDetailViewController(cardList: Array(deckDTO.list), selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToAddCardViewController() {
        let nextController = AddCardViewController()
        nextController.isDeckBuilder = true
        nextController.deckDTO = deckDTO
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
