//
//  HttpClient+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension HttpClient {

    var activeTasks: [URLSessionDataTask]? {
        Mirror.extract(variable: "activeTasks", from: self)
    }
}
