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
        if #available(iOS 13.0, *) {
            // Set the standard appearance
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = ColorPalette.appThemeV2

            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance

            // Set the scroll edge appearance
            let scrollNavBarAppearance = UINavigationBarAppearance()
            scrollNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            scrollNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            scrollNavBarAppearance.backgroundColor = ColorPalette.appThemeV2

            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = scrollNavBarAppearance

            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().tintColor = .white
        } else {
            let navigationBarAppearance = UINavigationBar.appearance()
            navigationBarAppearance.tintColor = .white
            navigationBarAppearance.barStyle = .black
            navigationBarAppearance.isTranslucent = true
            navigationBarAppearance.barTintColor = ColorPalette.appTheme
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
