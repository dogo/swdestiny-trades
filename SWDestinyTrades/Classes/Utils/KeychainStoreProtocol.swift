//
//  KeychainStoreProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol KeychainStoreProtocol {

    func data(for key: String) -> Data?

    @discardableResult
    func set(_ data: Data, for key: String) -> Bool

    func delete(_ key: String)
}
