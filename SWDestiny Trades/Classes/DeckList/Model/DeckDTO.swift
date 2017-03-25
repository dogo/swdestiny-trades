//
//  DeckDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class DeckDTO: Object {
    dynamic var id = NSUUID().uuidString // swiftlint:disable:this identifier_name
    dynamic var name = ""
    let list = List<CardDTO>()

    override class func primaryKey() -> String {
        return "id"
    }
}
