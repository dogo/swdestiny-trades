//
//  SearchListViewControllerProtocol.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol SearchListViewControllerProtocol where Self: UIViewController {
    func setNavigationTitle(_ title: String)
    func startLoading()
    func stopLoading()
    func updateTableViewData(_ cardList: [CardDTO])
    func showNetworkErrorMessage()
}
