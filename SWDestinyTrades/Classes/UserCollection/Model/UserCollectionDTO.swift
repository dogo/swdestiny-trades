//
//  UserCollectionDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/15/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

final class UserCollectionDTO: Object, Storable {

    @objc dynamic var id = NSUUID().uuidString
    let myCollection = List<CardDTO>()

    override class func primaryKey() -> String {
        return "id"
    }
}
