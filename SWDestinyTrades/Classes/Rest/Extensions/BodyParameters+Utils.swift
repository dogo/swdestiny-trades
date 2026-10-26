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

    var formEncoded: Data? {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&=+")
        return sorted { $0.key < $1.key }
            .map { key, value in
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
                return "\(key)=\(encodedValue)"
            }
            .joined(separator: "&")
            .data(using: .utf8)
    }
}
