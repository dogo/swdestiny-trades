//
//  BodyParameters+Utils.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

extension BodyParameters {

    var dataEncoded: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .sortedKeys)
    }
}
