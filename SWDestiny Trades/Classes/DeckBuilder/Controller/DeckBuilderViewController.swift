//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderViewController: UIViewController {
    private lazy var deckBuilderView = DeckBuilderTableView(delegate: self)
    private lazy var navigator = DeckBuilderNavigator(self.navigationController)
    private let database: DatabaseProtocol?
    private var deckDTO: DeckDTO

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?, with deck: DeckDTO) {
        self.database = database
        deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = deckBuilderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        deckBuilderView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = deckDTO.name

        loadData(deck: deckDTO)
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddToDeckViewController))
        let deckGraphBarItem = UIBarButtonItem(image: Asset.NavigationBar.icChart.image, style: .plain, target: self, action: #selector(navigateToDeckGraphViewController))
        navigationItem.rightBarButtonItems = [addCardBarItem, deckGraphBarItem, shareBarItem]
    }

    func loadData(deck: DeckDTO) {
        deckBuilderView.updateTableViewData(deck: deck)
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let deck = notification.userInfo?["deckDTO"] as? DeckDTO {
            loadData(deck: deck)
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }

    @objc
    func navigateToAddToDeckViewController() {
        navigator.navigate(to: .addToDeck(database: database, with: deckDTO))
    }

    @objc
    func navigateToDeckGraphViewController() {
        navigator.navigate(to: .deckGraph(with: deckDTO))
    }

    @objc
    func share(_ sender: UIBarButtonItem) {
        var deckList: String = "\(deckDTO.name)\n\n"

        if let deckObject = deckBuilderView.tableViewDatasource?.deckList {
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
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

extension DeckBuilderViewController: DeckBuilderProtocol {
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
