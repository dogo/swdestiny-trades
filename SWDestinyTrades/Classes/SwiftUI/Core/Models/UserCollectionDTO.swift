//
//  UserCollectionDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/15/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

final class UserCollectionDTO: Object, Storable, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var myCollection = List<CardDTO>()
}
