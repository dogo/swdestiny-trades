//
//  AddCardViewModel+Stub.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 31/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension AddCardViewModel {

    static func stub(person: PersonDTO? = nil,
                     userCollection: UserCollectionDTO? = nil,
                     type: AddCardType) -> Self {
        return AddCardViewModel(person: person, userCollection: userCollection, type: type)
    }
}
