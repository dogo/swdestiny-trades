//
//  LoggerProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 23/10/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

enum Events: String {
    case setsList
    case cardsList
    case allCards
}

protocol LoggerProtocol {
    func setup()
    func log(event: Events, parameters: [String: Any]?)
}
