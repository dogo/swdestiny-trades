//
//  DeckGraphViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DeckGraphViewControllerProtocol: AnyObject {

    func updateCollecionViewData(deck: DeckDTO)
    func setNavigationTitle(_ title: String)
}
