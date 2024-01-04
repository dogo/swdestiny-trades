//
//  AddToDeckViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol AddToDeckViewType where Self: UIView {

    var didSelectCard: ((CardDTO) -> Void)? { get set }
    var didSelectAccessory: ((CardDTO) -> Void)? { get set }
    var doingSearch: ((String) -> Void)? { get set }
    var didSelectRemote: (() -> Void)? { get set }
    var didSelectLocal: (() -> Void)? { get set }

    func startLoading()
    func stopLoading()
    func updateSearchList(_ cards: [CardDTO])
    func doingSearch(_ query: String)
}
