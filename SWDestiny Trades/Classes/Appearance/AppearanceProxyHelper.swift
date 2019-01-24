//
//  AppearanceProxyHelper.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

enum AppearanceProxyHelper {

    static func customizeTabBar() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .white
        tabBarAppearance.barTintColor = ColorPalette.appTheme
    }

    static func customizeNavigationBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.barStyle = .blackTranslucent
        navigationBarAppearance.barTintColor = ColorPalette.appTheme
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearance.prefersLargeTitles = true
        }
    }
}
