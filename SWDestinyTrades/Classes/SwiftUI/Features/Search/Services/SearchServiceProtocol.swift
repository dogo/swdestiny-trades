//
//  SearchServiceProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {

    func search(query: String) async throws -> [CardDTO]
}
