//
//  NavigationCoordinatorProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 02/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
protocol NavigationCoordinatorProtocol: AnyObject {

    var selectedTab: AppTab { get set }

    var setsPath: NavigationPath { get set }
    var deckPath: NavigationPath { get set }
    var loanPath: NavigationPath { get set }
    var collectionPath: NavigationPath { get set }

    func navigate(to destination: AppDestination)
    func navigate(to destination: AppDestination, on tab: AppTab)
}
