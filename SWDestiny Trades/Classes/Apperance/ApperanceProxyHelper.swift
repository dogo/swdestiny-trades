//
//  ApperanceProxyHelper.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

struct ApperanceProxyHelper {
    
    static func customizeTabBar() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
    }
    
    static func customizeNavigationBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barStyle = .blackTranslucent
        navigationBarAppearance.barTintColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
