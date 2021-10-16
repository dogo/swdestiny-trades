//
//  Decoder+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/6/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeSafely<T>(key: K, defaultValue: T) throws -> T
        where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}
