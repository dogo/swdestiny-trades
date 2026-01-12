//
//  PersonDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable attributes
class PersonDTO: Object, Storable, Identifiable {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""
    let lentMe = List<CardDTO>()
    let borrowed = List<CardDTO>()

    override class func primaryKey() -> String {
        return "id"
    }

    override var hash: Int {
        return id.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? PersonDTO else { return false }
        return id == other.id
    }
}

// swiftlint:enable attributes
