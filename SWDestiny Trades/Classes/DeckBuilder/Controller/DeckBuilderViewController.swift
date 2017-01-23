//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderViewController: UIViewController {

    fileprivate let deckBuilderView = DeckBuilderView()
    fileprivate var deckDTO: DeckDTO

    // MARK: - Life Cycle

    init(with deck: DeckDTO) {
        deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = deckBuilderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        loadData(deck: deckDTO)

        deckBuilderView.deckBuilderTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = deckDTO.name
    }

    private func setupNavigationItem() {
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCardViewController))
        let deckGraphBarItem = UIBarButtonItem(image: UIImage(named: "ic_chart"), style: .plain, target: self, action: #selector(navigateToDeckGraphViewController))
        self.navigationItem.rightBarButtonItems = [addCardBarItem, deckGraphBarItem]
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

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cardList, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToAddCardViewController() {
        let nextController = AddCardViewController(deck: deckDTO, isDeckBuilder: true)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToDeckGraphViewController() {
        let nextController = DeckGraphViewController(deck: deckDTO)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
