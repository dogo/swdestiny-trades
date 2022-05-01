//
//  AppDelegate.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var database: RealmDatabase?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        database = try? RealmDatabase()
        RealmMigrations.performMigrations(with: database)

        AppearanceProxyHelper.customizeTabBar()
        AppearanceProxyHelper.customizeNavigationBar()
        AppearanceProxyHelper.customizeUITableView()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = SWDTabBarViewController(database: database)
        window?.makeKeyAndVisible()

        return true
    }
}
