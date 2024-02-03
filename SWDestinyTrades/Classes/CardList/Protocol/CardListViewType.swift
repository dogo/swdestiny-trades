//
//  CardListViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol CardListViewType where Self: UIView {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)? { get set }

    func startLoading()
    func stopLoading()
    func updateCardList(_ cards: [CardDTO])
}
