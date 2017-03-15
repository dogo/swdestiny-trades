//
//  UserCollectionViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class UserCollectionViewController: UIViewController {

    fileprivate let userCollectionView = UserCollectionView()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = userCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        //loadDataFromRealm()

        userCollectionView.userCollectionTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = NSLocalizedString("My Collection", comment: "")
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        self.navigationItem.rightBarButtonItems = [shareBarItem]
    }

    func loadDataFromRealm() {
        //userCollectionView.userCollectionTableView.updateTableViewData(deck: deck)
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cardList, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func share(_ sender: UIBarButtonItem) {

        let activityVC = UIActivityViewController(activityItems: [SwdShareProvider(subject: "", text: ""), "Shared with SWD Trades for iOS"], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.saveToCameraRoll, .postToFlickr, .postToVimeo, .assignToContact, .addToReadingList, .postToFacebook]

        activityVC.popoverPresentationController?.barButtonItem = sender
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
