//
//  CardReturnable.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

protocol CardReturnable {
    func getCard(at index: IndexPath) -> CardDTO?
    func getCardList() -> [CardDTO]
}
