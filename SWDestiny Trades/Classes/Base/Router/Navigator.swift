//
//  Navigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

protocol Navigator {
    associatedtype Destination

    func navigate(to destination: Destination)
}
