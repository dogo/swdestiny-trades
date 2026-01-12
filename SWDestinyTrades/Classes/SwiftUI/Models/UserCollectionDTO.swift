//
//  UserCollectionDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/15/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable attributes
final class UserCollectionDTO: Object, Storable, Identifiable {

    @objc dynamic var id = NSUUID().uuidString
    let myCollection = List<CardDTO>()

    // swiftlint:disable:next static_over_final_class
    override class func primaryKey() -> String {
        return "id"
    }
}

// swiftlint:enable attributes
