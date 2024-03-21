//
//  UserCollectionDTO+Stub.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension UserCollectionDTO {

    static func stub(collection: [CardDTO] = []) -> UserCollectionDTO {
        let userCollection = UserCollectionDTO()
        userCollection.myCollection.append(objectsIn: collection)
        return userCollection
    }
}
