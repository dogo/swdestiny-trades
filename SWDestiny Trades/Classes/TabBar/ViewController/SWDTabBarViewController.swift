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
        setsTab.tabBarItem = UITabBarItem(title: NSLocalizedString("CARDS", comment: ""), image: UIImage(named: "ic_cards"), selectedImage: UIImage(named: "ic_cards_filled"))

        // Create DeckListViewController Tab
        let decktab = UINavigationController(rootViewController: DeckListViewController())
        decktab.tabBarItem = UITabBarItem(title: NSLocalizedString("DECKS", comment: ""), image: UIImage(named: "ic_cards"), selectedImage: UIImage(named: "ic_cards_filled"))

        // Create PeopleListViewController Tab
        let loansTab = UINavigationController(rootViewController: PeopleListViewController())
        loansTab.tabBarItem = UITabBarItem(title: NSLocalizedString("LOANS", comment: ""), image: UIImage(named: "ic_loans"), selectedImage: nil)

        self.viewControllers = [setsTab, decktab, loansTab]
    }
}
