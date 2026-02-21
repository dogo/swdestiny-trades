//
//  PersonDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class PersonDTO: Object, Storable, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var lastName: String = ""
    @Persisted var lentMe = List<CardDTO>()
    @Persisted var borrowed = List<CardDTO>()
}
