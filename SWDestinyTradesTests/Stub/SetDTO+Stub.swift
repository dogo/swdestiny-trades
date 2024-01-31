//
//  SetDTO+Stub.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension SetDTO {

    convenience init(name: String, code: String) {
        self.init()
        self.name = name
        self.code = code
    }

    static func stub(name: String = "Awakenings", code: String = "AW") -> SetDTO {
        return SetDTO(name: name, code: code)
    }
}
