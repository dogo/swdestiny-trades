//
//  CoreDataEntities.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreData
import Foundation

// MARK: - CardMO

class CardMO: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var subtitle: String
    @NSManaged var setCode: String
    @NSManaged var setName: String
    @NSManaged var typeCode: String
    @NSManaged var typeName: String
    @NSManaged var factionCode: String
    @NSManaged var factionName: String
    @NSManaged var affiliationCode: String
    @NSManaged var affiliationName: String
    @NSManaged var rarityCode: String
    @NSManaged var rarityName: String
    @NSManaged var position: Int32
    @NSManaged var ttscardid: String
    @NSManaged var cost: Int32
    @NSManaged var health: Int32
    @NSManaged var points: String
    @NSManaged var text: String
    @NSManaged var deckLimit: Int32
    @NSManaged var flavor: String
    @NSManaged var illustrator: String
    @NSManaged var isUnique: Bool
    @NSManaged var hasDie: Bool
    @NSManaged var externalUrl: String
    @NSManaged var imageUrl: String
    @NSManaged var label: String
    @NSManaged var cp: Int32
    @NSManaged var quantity: Int32
    @NSManaged var isElite: Bool
    @NSManaged var dieFaces: NSArray?
}

// MARK: - SetMO

class SetMO: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var code: String
}

// MARK: - DeckMO

class DeckMO: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
}

// MARK: - PersonMO

class PersonMO: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var lastName: String
}

// MARK: - UserCollectionMO

class UserCollectionMO: NSManagedObject {
    @NSManaged var id: String
}
