//
//  UserCollectionViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

final class UserCollectionViewController: UIViewController {

    fileprivate let userCollectionView = UserCollectionView()
    fileprivate var currentSortIndex = 0
    fileprivate var navigator: UserCollectionNavigator?

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

        self.navigator = UserCollectionNavigator(self.navigationController)

        setupNavigationItem()

        userCollectionView.userCollectionTableView.didSelectCard = { [unowned self] list, card in
            self.navigateToCardDetailViewController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.myCollection

        loadDataFromRealm()

        configureFTPopOverMenu()
    }

    // MARK: - Private

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCardViewController))
        self.navigationItem.rightBarButtonItems = [addCardBarItem, shareBarItem]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icSort.image, style: .plain, target: self, action: #selector(sort(_:event:)))
    }

    func loadDataFromRealm() {
        let user = UserCollectionViewController.getUserCollection()
        userCollectionView.userCollectionTableView.updateTableViewData(collection: user)
        userCollectionView.userCollectionTableView.sort(currentSortIndex)
    }

    func configureFTPopOverMenu() {
        let config = FTConfiguration.shared
        config.textColor = .white
        config.backgoundTintColor = ColorPalette.appTheme
        config.borderColor = ColorPalette.appTheme
        config.menuSeparatorColor = .lightGray
        config.textAlignment = .center
    }

    static func addToCollection(carDTO: CardDTO) {
        let user = getUserCollection()
        do {
            try RealmManager.shared.realm.write {
                let predicate = NSPredicate(format: "code == %@", carDTO.code)
                if let index = user.myCollection.index(matching: predicate) {
                    let newCard = user.myCollection[index]
                    newCard.quantity += 1
                } else {
                    user.myCollection.append(carDTO)
                }
                RealmManager.shared.realm.add(user, update: true)
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    static func getUserCollection() -> UserCollectionDTO {
        var user: UserCollectionDTO

        let result = RealmManager.shared.realm.objects(UserCollectionDTO.self)

        if let userCollection = result.first {
            user = userCollection
        } else {
            user = UserCollectionDTO()
            do {
                try RealmManager.shared.realm.write {
                    RealmManager.shared.realm.add(user, update: true)
                }
            } catch let error as NSError {
                print("Error opening realm: \(error)")
            }
        }
        return user
    }

    // MARK: - Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        self.navigator?.navigate(to: .cardDetail(with: cardList, card: card))
    }

    @objc
    func navigateToAddCardViewController() {
        self.navigator?.navigate(to: .addCard(with: UserCollectionViewController.getUserCollection()))
    }

    @objc
    func share(_ sender: UIBarButtonItem) {

        var collectionList: String = ""

        if let cardList = userCollectionView.userCollectionTableView.tableViewDatasource?.getCardList() {
            for card in cardList {
                collectionList.append(String(format: "%d %@\n", card.quantity, card.name))
            }
        }

        let activityVC = UIActivityViewController(activityItems: [SwdShareProvider(subject: L10n.myCollection, text: collectionList), L10n.shareText], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.saveToCameraRoll, .postToFlickr, .postToVimeo, .assignToContact, .addToReadingList, .postToFacebook]

        activityVC.popoverPresentationController?.barButtonItem = sender
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }

    @objc
    func sort(_ sender: UIBarButtonItem, event: UIEvent) {
        FTPopOverMenu.showForEvent(event: event, with: [L10n.aToZ, L10n.cardNumber, L10n.color], done: { selectedIndex -> Void in
            self.userCollectionView.userCollectionTableView.sort(selectedIndex)
            self.currentSortIndex = selectedIndex
        }, cancel: {
        })
    }
}
