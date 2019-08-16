//
//  SetDTOMock.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestiny_Trades

enum SetDTOMock {

    static func mockedSetDTO() -> Result<[SetDTO]?, APIError> {

        let mockInfo: [String: Any] = ["name": "Awakenings",
                                       "code": "AW",
                                       "position": 1,
                                       "available": "2016-12-01",
                                       "known": 174,
                                       "total": 174,
                                       "url": "https://swdestinydb.com/set/AW"]

        let result: Result<[SetDTO]?, APIError>
        let jsonData = try? JSONSerialization.data(withJSONObject: [mockInfo], options: [])
        do {
            result = .success(try JSONDecoder().decode([SetDTO].self, from: jsonData!))
        } catch {
            result = .failure(APIError.jsonConversionFailure)
        }
        return result
    }
}
