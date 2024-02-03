//
//  CardListViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol CardListViewControllerProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func updateCardList(_ cards: [CardDTO])
    func showNetworkErrorMessage()
    func setNavigationTitle(_ title: String)
}
