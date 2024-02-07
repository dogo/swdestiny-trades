//
//  SetsListViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SetsListViewControllerProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func endRefreshControl()
    func updateSetList(_ setList: [SetDTO])
    func setupNavigationItem()
    func showNetworkErrorMessage()
}
