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

    private var currentSortIndex = 0
    private lazy var userCollectionView = UserCollectionTableView(delegate: self)
    private lazy var navigator = UserCollectionNavigator(self.navigationController)
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
        self.view = userCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        userCollectionView.didSelectCard = { [weak self] list, card in
            self?.navigateToCardDetailViewController(cardList: list, card: card)
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

    private func createDatabase(object: UserCollectionDTO) {
        try? self.database?.save(object: object)
    }

    func loadDataFromRealm() {
        let user = self.getUserCollection()
        userCollectionView.updateTableViewData(collection: user)
        userCollectionView.sort(currentSortIndex)
    }

    func configureFTPopOverMenu() {
        let config = FTConfiguration.shared
        config.backgoundTintColor = ColorPalette.appTheme
        config.borderColor = ColorPalette.appTheme
        config.menuSeparatorColor = .lightGray
    }

    func addToCollection(carDTO: CardDTO) {
        let user = getUserCollection()
        try? self.database?.update {
            let predicate = NSPredicate(format: "code == %@", carDTO.code)
            if let index = user.myCollection.index(matching: predicate) {
                let newCard = user.myCollection[index]
                newCard.quantity += 1
            } else {
                user.myCollection.append(carDTO)
            }
        }
    }

    func getUserCollection() -> UserCollectionDTO {
        var user = UserCollectionDTO()
        try? self.database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] results in
            if let userCollection = results.first {
                user = userCollection
            } else {
                self?.createDatabase(object: user)
            }
        }
        return user
    }

    // MARK: - Navigation

    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(database: self.database, with: cardList, card: card))
    }

    @objc
    func navigateToAddCardViewController() {
        self.navigator.navigate(to: .addCard(database: self.database, with: self.getUserCollection()))
    }

    @objc
    func share(_ sender: UIBarButtonItem) {

        var collectionList: String = ""

        if let cardList = userCollectionView.tableViewDatasource?.getCardList() {
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

        let cellConfi = FTCellConfiguration()
        cellConfi.textColor = .white
        cellConfi.textAlignment = .center

        let cellConfis = Array(repeating: cellConfi, count: 3)

        FTPopOverMenu.showForEvent(event: event, with: [L10n.aToZ, L10n.cardNumber, L10n.color], menuImageArray: nil,
                                   cellConfigurationArray: cellConfis, done: { [weak self] selectedIndex in
            self?.userCollectionView.sort(selectedIndex)
            self?.currentSortIndex = selectedIndex
        }, cancel: {
        })
    }
}

extension UserCollectionViewController: UserCollectionProtocol {

    func stepperValueChanged(newValue: Int, card: CardDTO) {
        try? self.database?.update {
            card.quantity = newValue
        }
    }

    func remove(at index: Int) {
        try? self.database?.update { [weak self] in
            self?.getUserCollection().myCollection.remove(at: index)
        }
    }
}
