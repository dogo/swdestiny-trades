//
//  AppDelegate.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var database: DatabaseProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.database = try? RealmDatabase()
        RealmMigrations.performMigrations(with: self.database)

        AppearanceProxyHelper.customizeTabBar()
        AppearanceProxyHelper.customizeNavigationBar()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = SWDTabBarViewController(database: self.database)
        self.window?.makeKeyAndVisible()

        return true
    }
}
