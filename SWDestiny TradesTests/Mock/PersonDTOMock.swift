//
//  PersonDTOMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestiny_Trades

final class PersonDTOMock {

    static func mockedPersonDTO() -> PersonDTO {
        let person = PersonDTO()
        person.name = "User"
        person.lastName = "Mock"
        return person
    }
}