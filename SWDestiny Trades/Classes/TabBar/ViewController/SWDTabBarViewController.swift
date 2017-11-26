//
//  SWDTabBarViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SWDTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create SetsListViewController Tab
        let setsTab = UINavigationController(rootViewController: SetsListViewController())
        setsTab.tabBarItem = UITabBarItem(title: L10n.cards, image: Asset.Tabbar.icCards.image, selectedImage: Asset.Tabbar.icCardsFilled.image)

        // Create DeckListViewController Tab
        let decktab = UINavigationController(rootViewController: DeckListViewController())
        decktab.tabBarItem = UITabBarItem(title: L10n.decks, image: Asset.Tabbar.icDecks.image, selectedImage: nil)

        // Create PeopleListViewController Tab
        let loansTab = UINavigationController(rootViewController: PeopleListViewController())
        loansTab.tabBarItem = UITabBarItem(title: L10n.loans, image: Asset.Tabbar.icLoans.image, selectedImage: nil)

        // Create UserCollectionViewController Tab
        let collectionTab = UINavigationController(rootViewController: UserCollectionViewController())
        collectionTab.tabBarItem = UITabBarItem(title: L10n.collection, image: Asset.Tabbar.icCollection.image, selectedImage: nil)

        self.viewControllers = [setsTab, decktab, loansTab, collectionTab]
    }
}
