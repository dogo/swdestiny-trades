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
        setsTab.tabBarItem = UITabBarItem(title: L10n.cards, image: UIImage(named: "ic_cards"), selectedImage: UIImage(named: "ic_cards_filled"))

        // Create DeckListViewController Tab
        let decktab = UINavigationController(rootViewController: DeckListViewController())
        decktab.tabBarItem = UITabBarItem(title: L10n.decks, image: UIImage(named: "ic_decks"), selectedImage: nil)

        // Create PeopleListViewController Tab
        let loansTab = UINavigationController(rootViewController: PeopleListViewController())
        loansTab.tabBarItem = UITabBarItem(title: L10n.loans, image: UIImage(named: "ic_loans"), selectedImage: nil)

        // Create UserCollectionViewController Tab
        let collectionTab = UINavigationController(rootViewController: UserCollectionViewController())
        collectionTab.tabBarItem = UITabBarItem(title: L10n.collection, image: UIImage(named: "ic_collection"), selectedImage: nil)

        self.viewControllers = [setsTab, decktab, loansTab, collectionTab]
    }
}
