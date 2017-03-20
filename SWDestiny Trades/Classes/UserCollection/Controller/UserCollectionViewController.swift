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

        userCollectionView.userCollectionTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = NSLocalizedString("MY_COLLECTION", comment: "")

        loadDataFromRealm()
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCardViewController))
        self.navigationItem.rightBarButtonItems = [addCardBarItem, shareBarItem]
    }

    func loadDataFromRealm() {
        let user = UserCollectionViewController.getUserCollection()
        userCollectionView.userCollectionTableView.updateTableViewData(collection: user)
    }

    static func addToCollection(card: CardDTO) {
        let user = getUserCollection()
        try! RealmManager.shared.realm.write {
            let predicate = NSPredicate(format: "code == %@", card.code)
            let index = user.myCollection.index(matching: predicate)
            if index == nil {
                user.myCollection.append(card)
            } else {
                let newCard = user.myCollection[index!]
                newCard.quantity += 1
            }
            RealmManager.shared.realm.add(user, update: true)
        }
    }

    static func getUserCollection() -> UserCollectionDTO {
        var user = UserCollectionDTO()
        let result = RealmManager.shared.realm.objects(UserCollectionDTO.self)
        if let userCollection = result.first {
            user = userCollection
        }
        return user
    }

    // MARK: Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cardList, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToAddCardViewController() {
        let nextController = AddCardViewController(userCollection: UserCollectionViewController.getUserCollection(), isUserCollection: true)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func share(_ sender: UIBarButtonItem) {

        var collectionList: String = ""

        if let cardList = userCollectionView.userCollectionTableView.tableViewDatasource?.getCardList() {
            for card in cardList {
                collectionList.append(String(format: "%d %@\n", card.quantity, card.name))
            }
        }

        let activityVC = UIActivityViewController(activityItems: [SwdShareProvider(subject: NSLocalizedString("MY_COLLECTION", comment: ""), text: collectionList), NSLocalizedString("SHARE_TEXT", comment: "")], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.saveToCameraRoll, .postToFlickr, .postToVimeo, .assignToContact, .addToReadingList, .postToFacebook]

        activityVC.popoverPresentationController?.barButtonItem = sender
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }    }
}
