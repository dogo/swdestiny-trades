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
    fileprivate lazy var navigator = DeckBuilderNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(with deck: DeckDTO) {
        deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = deckBuilderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        deckBuilderView.deckBuilderTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = deckDTO.name

        loadData(deck: deckDTO)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddToDeckViewController))
        let deckGraphBarItem = UIBarButtonItem(image: Asset.NavigationBar.icChart.image, style: .plain, target: self, action: #selector(navigateToDeckGraphViewController))
        self.navigationItem.rightBarButtonItems = [addCardBarItem, deckGraphBarItem, shareBarItem]
    }

    func loadData(deck: DeckDTO) {
        deckBuilderView.deckBuilderTableView.updateTableViewData(deck: deck)
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        if let deck = notification.userInfo?["deckDTO"] as? DeckDTO {
            loadData(deck: deck)
        }
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(with: cardList, card: card))
    }

    @objc
    func navigateToAddToDeckViewController() {
        self.navigator.navigate(to: .addToDeck(with: deckDTO))
    }

    @objc
    func navigateToDeckGraphViewController() {
        self.navigator.navigate(to: .deckGraph(with: deckDTO))
    }

    @objc
    func share(_ sender: UIBarButtonItem) {

        var deckList: String = "\(deckDTO.name)\n\n"

        if let deckObject = deckBuilderView.deckBuilderTableView.tableViewDatasource?.deckList {
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
