//
//  SearchViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 17/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewType where Self: UIView {

    var didSelectCard: ((CardDTO) -> Void)? { get set }
    var doingSearch: ((String) -> Void)? { get set }

    func startLoading()
    func stopLoading()
    func updateSearchList(_ cards: [CardDTO])
}
