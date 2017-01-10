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
        
        // Create Tab one
        let tabOne = UINavigationController(rootViewController: SetsListViewController())
        tabOne.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(named: "ic_cards"), selectedImage: UIImage(named: "ic_cards_filled"))
        
        // Create Tab two
        let tabTwo = UINavigationController(rootViewController: PeopleListViewController())
        tabTwo.tabBarItem = UITabBarItem(title: "Loans", image: UIImage(named: "ic_loans"), selectedImage: nil)
        
        self.viewControllers = [tabOne, tabTwo]
    }
}
