//
//  PersonDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class LoanDTO: Object {
    let card: CardDTO? = nil
    dynamic var hasLentMe = false
}

class PersonDTO: Object {
    dynamic var name = ""
    dynamic var lastName = ""
    let loans = List<LoanDTO>()
}
