//
//  SetsViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol SetsListViewType where Self: UIView {
    var didSelectSet: ((SetDTO) -> Void)? { get set }

    func startLoading()
    func stopLoading()
    func endRefreshControl()
    func updateSetList(_ sets: [SetDTO])
    func setupPullToRefresh(target: Any, action: Selector)
}
