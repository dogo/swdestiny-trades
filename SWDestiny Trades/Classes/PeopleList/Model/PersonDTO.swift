//
//  PersonDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class PersonDTO: Object {
    @objc dynamic var id = NSUUID().uuidString // swiftlint:disable:this identifier_name
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""
    let lentMe = List<CardDTO>()
    let borrowed = List<CardDTO>()

    override class func primaryKey() -> String {
        return "id"
    }
}
