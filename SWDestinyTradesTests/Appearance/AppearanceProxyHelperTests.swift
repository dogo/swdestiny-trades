//
//  AppearanceProxyHelperTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 20/04/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AppearanceProxyHelperTests: XCTestCase {

    func test_customize_tabBar() {
        AppearanceProxyHelper.customizeTabBar()

        let tabBarAppearance = UITabBar.appearance()
        XCTAssertEqual(tabBarAppearance.tintColor, .white)
        XCTAssertEqual(tabBarAppearance.barTintColor, ColorPalette.appTheme)

        if #available(iOS 15.0, *) {
            let tabBarScrollEdgeAppearance = UITabBar.appearance(whenContainedInInstancesOf: [UITabBarController.self]).scrollEdgeAppearance
            XCTAssertEqual(tabBarScrollEdgeAppearance?.backgroundColor, ColorPalette.appTheme)
        }
    }

    func test_customize_UITableView() {
        AppearanceProxyHelper.customizeUITableView()

        if #available(iOS 15.0, *) {
            XCTAssertEqual(UITableView.appearance().sectionHeaderTopPadding, .zero)
        }
    }

    func test_customize_navigationBar() {
        AppearanceProxyHelper.customizeNavigationBar()

        if #available(iOS 13.0, *) {
            let standardAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance
            XCTAssertEqual(standardAppearance.backgroundColor, ColorPalette.appThemeV2)

            let scrollEdgeAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance
            XCTAssertEqual(scrollEdgeAppearance?.backgroundColor, ColorPalette.appThemeV2)

            XCTAssertTrue(UINavigationBar.appearance().prefersLargeTitles)
            XCTAssertEqual(UINavigationBar.appearance().tintColor, .white)
        }
    }
}
