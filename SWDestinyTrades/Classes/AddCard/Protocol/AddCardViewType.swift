//
//  AddCardViewType.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol AddCardViewType where Self: UIView {

    var didSelectCard: ((CardDTO) -> Void)? { get set }
    var didSelectAccessory: ((CardDTO) -> Void)? { get set }
    var doingSearch: ((String) -> Void)? { get set }

    func startLoading()
    func stopLoading()
    func updateSearchList(_ cards: [CardDTO])
    func doingSearch(_ query: String)
}
