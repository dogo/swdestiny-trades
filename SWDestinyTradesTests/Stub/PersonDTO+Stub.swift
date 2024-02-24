//
//  PersonDTO+Stub.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestinyTrades

extension PersonDTO {
    static func stub(name: String = "User",
                     lastName: String = "Mock",
                     lentMe: [CardDTO] = [],
                     borrowed: [CardDTO] = []) -> PersonDTO {
        let person = PersonDTO()
        person.name = name
        person.lastName = lastName
        person.lentMe.append(objectsIn: lentMe)
        person.borrowed.append(objectsIn: borrowed)
        return person
    }
}
