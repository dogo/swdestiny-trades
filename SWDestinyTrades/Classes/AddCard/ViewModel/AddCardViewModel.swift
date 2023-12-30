//
//  AddCardViewModel.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

enum AddCardType {
    case lent
    case borrow
    case collection
}

struct AddCardViewModel {

    let person: PersonDTO?
    let userCollection: UserCollectionDTO?
    let type: AddCardType
}
