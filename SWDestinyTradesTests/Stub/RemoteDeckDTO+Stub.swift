//
//  RemoteDeckDTO+Stub.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension RemoteDeckDTO {

    static func stub(id: Int = 1,
                     name: String = "Ewoks",
                     slots: [String: Int] = ["11093": 1, "05117": 2]) -> RemoteDeckDTO {
        return RemoteDeckDTO(id: id, name: name, slots: slots.mapValues(Slot.init))
    }
}
