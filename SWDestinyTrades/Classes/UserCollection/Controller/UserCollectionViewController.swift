//
//  UserCollectionViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import FTPopOverMenu
import UIKit

final class UserCollectionViewController: UIViewController {

    private var currentSortIndex = 0
    private let userCollectionView: UserCollectionViewType
    private lazy var navigator = UserCollectionNavigator(self)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(with view: UserCollectionViewType = UserCollectionTableView(), database: DatabaseProtocol?) {
        userCollectionView = view
        self.database = database
        super.init(nibName: nil, bundle: nil)
        userCollectionView.userCollectionDelegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = userCollectionView
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

        navigationItem.title = L10n.myCollection

        loadDataFromRealm()
    }

    // MARK: - Private

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addCardBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddCardViewController))
        navigationItem.rightBarButtonItems = [addCardBarItem, shareBarItem]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icSort.image, style: .plain, target: self, action: #selector(sort(_:event:)))
    }

    private func createDatabase(object: UserCollectionDTO) {
        try? database?.save(object: object)
    }

    private func loadDataFromRealm() {
        let user = getUserCollection()
        userCollectionView.updateTableViewData(collection: user)
        userCollectionView.sort(currentSortIndex)
    }

    private func popOverMenuConfiguration() -> FTConfiguration {
        let config = FTConfiguration()
        config.backgoundTintColor = ColorPalette.appTheme
        config.borderColor = ColorPalette.appTheme
        config.menuSeparatorColor = .lightGray
        config.textColor = .white
        config.textAlignment = .center
        return config
    }

    private func addToCollection(carDTO: CardDTO) {
        let user = getUserCollection()
        try? database?.update {
            let predicate = NSPredicate(format: "code == %@", carDTO.code)
            if let index = user.myCollection.index(matching: predicate) {
                let newCard = user.myCollection[index]
                newCard.quantity += 1
            } else {
                user.myCollection.append(carDTO)
            }
        }
    }

    private func getUserCollection() -> UserCollectionDTO {
        var user = UserCollectionDTO()
        try? database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] results in
            if let userCollection = results.first {
                user = userCollection
            } else {
                self?.createDatabase(object: user)
            }
        }
        return user
    }

    // MARK: - Navigation

    private func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }

    @objc
    private func navigateToAddCardViewController() {
        navigator.navigate(to: .addCard(database: database, with: getUserCollection()))
    }

    @objc
    private func share(_ sender: UIBarButtonItem) {
        var collectionList = ""

        if let cardList = userCollectionView.getCardList() {
            for card in cardList {
                collectionList.append(String(format: "%d %@\n", card.quantity, card.name))
            }
        }

        let activityVC = UIActivityViewController(activityItems: [SwdShareProvider(subject: L10n.myCollection, text: collectionList), L10n.shareText], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.saveToCameraRoll,
                                            .postToFlickr,
                                            .postToVimeo,
                                            .assignToContact,
                                            .addToReadingList,
                                            .postToFacebook]

        activityVC.popoverPresentationController?.barButtonItem = sender
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }

    @objc
    private func sort(_ sender: UIBarButtonItem, event: UIEvent) {
        FTPopOverMenu.showForEvent(event: event,
                                   with: [L10n.aToZ, L10n.cardNumber, L10n.color],
                                   config: popOverMenuConfiguration(),
                                   done: { [weak self] selectedIndex in
                                       self?.userCollectionView.sort(selectedIndex)
                                       self?.currentSortIndex = selectedIndex
                                   }, cancel: {})
    }
}

extension UserCollectionViewController: UserCollectionProtocol {

    func stepperValueChanged(newValue: Int, card: CardDTO) {
        try? database?.update {
            card.quantity = newValue
        }
    }

    func remove(at index: Int) {
        try? database?.update { [weak self] in
            self?.getUserCollection().myCollection.remove(at: index)
        }
    }
}
