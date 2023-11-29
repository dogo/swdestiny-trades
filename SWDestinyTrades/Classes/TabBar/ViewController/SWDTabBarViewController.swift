//
//  SWDTabBarViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SWDTabBarViewController: UITabBarController {

    private weak var database: DatabaseProtocol?

    init(database: DatabaseProtocol?) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let factory = SWDTabBarFactory()

        // Create SetsListViewController Tab
        let setsTab = UINavigationController(rootViewController: factory.makeSetsList(with: database))
        setsTab.tabBarItem = UITabBarItem(title: L10n.cards, image: Asset.Tabbar.icCards.image, selectedImage: Asset.Tabbar.icCardsFilled.image)

        // Create DeckListViewController Tab
        let decktab = UINavigationController(rootViewController: DeckListViewController(database: database))
        decktab.tabBarItem = UITabBarItem(title: L10n.decks, image: Asset.Tabbar.icDecks.image, selectedImage: nil)

        // Create PeopleListViewController Tab
        let loansTab = UINavigationController(rootViewController: PeopleListViewController(database: database))
        loansTab.tabBarItem = UITabBarItem(title: L10n.loans, image: Asset.Tabbar.icLoans.image, selectedImage: nil)

        // Create UserCollectionViewController Tab
        let collectionTab = UINavigationController(rootViewController: UserCollectionViewController(database: database))
        collectionTab.tabBarItem = UITabBarItem(title: L10n.collection, image: Asset.Tabbar.icCollection.image, selectedImage: nil)

        viewControllers = [setsTab, decktab, loansTab, collectionTab]
    }
}
