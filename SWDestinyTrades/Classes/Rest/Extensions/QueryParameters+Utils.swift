//
//  QueryParameters+Utils.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

extension QueryParameters {

    nonisolated var items: [URLQueryItem] {
        return compactMap { URLQueryItem(name: $0, value: $1) }
    }
}
