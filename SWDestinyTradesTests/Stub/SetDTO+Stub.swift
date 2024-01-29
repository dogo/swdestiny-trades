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

    static let data: [[String: Any]] = [
        [
            "name": "Awakenings",
            "code": "AW",
            "position": 1,
            "available": "2016-12-01",
            "known": 174,
            "total": 174,
            "url": "http://swdestinydb.com/set/AW"
        ],
        [
            "name": "Spirit of Rebellion",
            "code": "SoR",
            "position": 2,
            "available": "2017-05-04",
            "known": 160,
            "total": 160,
            "url": "http://swdestinydb.com/set/SoR"
        ],
        [
            "name": "Empire at War",
            "code": "EaW",
            "position": 3,
            "available": "2017-09-14",
            "known": 160,
            "total": 160,
            "url": "https://swdestinydb.com/set/EaW"
        ],
        [
            "name": "Spark of Hope",
            "code": "SoH",
            "position": 11,
            "available": "2019-07-05",
            "known": 160,
            "total": 160,
            "url": "https://swdestinydb.com/set/SoH"
        ]
    ]

    static func stub() -> [SetDTO] {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        return try! JSONDecoder().decode([SetDTO].self, from: jsonData)
    }
}
