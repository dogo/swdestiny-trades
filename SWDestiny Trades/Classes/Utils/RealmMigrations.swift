//
//  RealmMigrations.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 30/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmMigrations {

    static func performMigrations() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 3
        var needsMigrationToV2 = false

        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: CardDTO.className()) { oldObject, newObject in
                    if let newObject = newObject {
                        if let oldObject = oldObject {
                            newObject["id"] = NSUUID().uuidString

                            if let oldCost = oldObject["cost"] as? Float {
                                newObject["cost"] = Int(oldCost)
                            }

                            if let id = oldObject["code"] as? String {
                                if kDices[id] != nil {
                                    let dieFaces = List<StringObject>()
                                    kDices[id]?.forEach { side in
                                        let string = StringObject()
                                        string.value = side
                                        dieFaces.append(string)
                                    }
                                    newObject["dieFaces"] = dieFaces
                                }
                            }
                        }
                    }
                }
            }
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: CardDTO.className()) { _, newObject in
                    if let newObject = newObject {
                        newObject["quantity"] = 1
                    }
                }
                needsMigrationToV2 = true
            }
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: CardDTO.className()) { _, newObject in
                    if let newObject = newObject {
                        newObject["isElite"] = false
                    }
                }
            }
        }

        Realm.Configuration.defaultConfiguration = config
        _ = RealmManager.shared.realm

        migrateCardQuantity(needsMigrationToV2)
    }

    fileprivate static func migrateCardQuantity(_ needsMigration: Bool) {
        let realm = RealmManager.shared.realm

        if needsMigration {
            let allDecks = realm.objects(DeckDTO.self)
            do {
                try realm.write {
                    for deck in allDecks {
                        var uniqueCards: [CardDTO] = []
                        for card in deck.list {
                            if uniqueCards.contains(card) {
                                card.quantity += 1
                            } else {
                                uniqueCards.append(card)
                            }
                        }
                        deck.list.removeAll()
                        deck.list.append(objectsIn: uniqueCards)
                    }
                }
            } catch let error as NSError {
                print("Error opening realm: \(error)")
            }
            let allPersons = realm.objects(PersonDTO.self)
            do {
                try realm.write {
                    for person in allPersons {
                        var borrowedCards: [CardDTO] = []
                        var lentMeCards: [CardDTO] = []
                        for card in person.borrowed {
                            if borrowedCards.contains(card) {
                                card.quantity += 1
                            } else {
                                borrowedCards.append(card)
                            }
                        }
                        for card in person.lentMe {
                            if lentMeCards.contains(card) {
                                card.quantity += 1
                            } else {
                                lentMeCards.append(card)
                            }
                        }
                        person.borrowed.removeAll()
                        person.lentMe.removeAll()
                        person.borrowed.append(objectsIn: borrowedCards)
                        person.lentMe.append(objectsIn: lentMeCards)
                    }
                }
            } catch let error as NSError {
                print("Error opening realm: \(error)")
            }
        }
    }
}

let kDices = [
    "01001": ["1RD", "2RD", "1F", "1Dc", "1R", "-"],
    "01002": ["1RD", "2RD", "2RD1", "1R", "-", "-"],
    "01003": ["2MD", "2MD", "3MD1", "1Dr", "1R", "-"],
    "01004": ["1RD", "2RD", "+2RD", "1Sh", "1R", "-"],
    "01005": ["3RD", "4RD", "5RD1", "2Sh", "Sp", "Sp"],
    "01006": ["1RD", "2RD", "3RD1", "1Dr", "Sp", "-"],
    "01007": ["1F", "2F", "2Dr", "1R", "Sp", "Sp"],
    "01008": ["2RD1", "+1RD", "+2RD", "1R", "Sp", "-"],
    "01009": ["1MD", "2MD", "1F", "2Dc1", "1R", "-"],
    "01010": ["2MD", "3MD", "2Dr", "1Sh", "1R", "-"],
    "01011": ["1MD", "2MD1", "1Sh", "1R", "Sp", "-"],
    "01012": ["1RD", "2RD", "1Dr", "1Dc", "1R", "-"],
    "01013": ["2Dr", "1Dc", "1R", "Sp", "Sp", "-"],
    "01014": ["1Dr", "1Sh", "1Sh", "2Sh", "1R", "-"],
    "01015": ["3MD1", "+2MD", "+3MD", "1Sh", "Sp", "-"],
    "01016": ["1F", "+1R", "Sp", "Sp", "-", "-"],
    "01017": ["1RD", "2RD1", "1R", "Sp", "-", "-"],
    "01018": ["2RD", "3RD1", "1Dr", "1Sh", "Sp", "-"],
    "01019": ["1RD", "+2RD", "1F", "1Sh", "1R", "-"],
    "01020": ["1F", "1F", "2Dr", "2Dc", "1R", "-"],
    "01021": ["1RD", "2RD", "1MD", "1R", "+1R", "-"],
    "01022": ["1RD", "1MD", "3MD1", "1Sh", "1R", "-"],
    "01023": ["2F", "3Dr1", "2Sh", "2R", "Sp", "Sp"],
    "01024": ["2MD", "4MD1", "1Dr", "1R", "Sp", "-"],
    "01025": ["2MD1", "+2MD", "1Dr", "1R", "Sp", "-"],
    "01026": ["+1RD", "+1MD", "1Dc", "Sp", "Sp", "-"],
    "01027": ["1RD", "2F", "1Dc", "1R", "1R", "-"],
    "01028": ["1RD", "2RD", "2RD1", "1F", "1R", "-"],
    "01029": ["2RD", "3RD1", "1Dr", "1R", "Sp", "-"],
    "01030": ["1RD", "2RD", "+1RD", "1Sh", "1R", "-"],
    "01031": ["0RD", "0RD", "0Dr", "0Sh", "0Dc", "-"],
    "01032": ["2RD", "3RD", "1Dr", "2Sh", "Sp", "-"],
    "01033": ["1F", "2Dr1", "1R", "Sp", "Sp", "-"],
    "01034": ["1MD", "1F", "1Sh", "2Sh", "1R", "+1R"],
    "01035": ["2MD", "3MD", "1F", "1Sh", "1R", "-"],
    "01036": ["1MD", "1MD", "2MD", "1F", "1R", "-"],
    "01037": ["1MD", "2MD", "1Sh", "2Sh", "1R", "-"],
    "01038": ["1MD", "+2MD", "1Dc", "1R", "+1R", "-"],
    "01039": ["1Dr", "1Dc", "1R", "Sp", "Sp", "-"],
    "01040": ["1F", "1F", "1Dr", "1R", "+1R", "-"],
    "01041": ["3MD1", "+3MD", "2Sh", "1R", "Sp", "-"],
    "01042": ["3RD", "2F", "3F", "3Dr", "2Sh", "2R"],
    "01043": ["1F", "1Dr", "1Sh", "1R", "Sp", "-"],
    "01044": ["1MD", "1MD", "3MD1", "1R", "Sp", "-"],
    "01045": ["1RD", "2RD", "1MD", "1Sh", "1R", "-"],
    "01046": ["2RD", "3RD1", "2Dr", "1R", "1R", "-"],
    "01047": ["2RD1", "3RD1", "1Dr", "1R", "1R", "-"],
    "01048": ["2F", "1Dc", "1R", "Sp", "Sp", "-"],
    "01049": ["3RD", "4RD", "2F", "3Dc", "2R", "Sp"],
    "01050": ["2F", "1Sh", "2Sh", "3Sh", "4Sh", "2Dr"],
    "01051": ["3RD", "3RD1", "+2RD", "1R", "-", "-"],
    "01052": ["1Dr", "1Sh", "1R", "Sp", "Sp", "-"],
    "01053": ["1F", "1Dr", "2Dr", "1Sh", "Sp", "-"],
    "01054": ["1RD", "2RD1", "+2RD", "1Sh", "-", "-"],
    "01055": ["2RD", "+3RD", "1Dr", "1R", "Sp", "-"],
    "01056": ["+1RD", "+1MD", "1F", "1Sh", "1R", "-"],
    "01057": ["1RD", "1Dr", "2Dr", "Sp", "Sp", "-"],
    "01058": ["1RD", "+2MD", "1F", "1R", "Sp", "-"],
    "01059": ["3MD1", "+2MD", "1Sh", "1R", "Sp", "-"],
    "01060": ["3RD1", "2Dr", "2Dc", "Sp", "Sp", "-"],
    "01061": ["1F", "1F", "1Sh", "1R", "+1R", "-"],
    "01062": ["1R", "+1R", "+1R", "Sp", "-", "-"],
    "01063": ["1RD", "2RD1", "+2RD", "1Sh", "1R", "-"],
    "01064": ["+2RD", "2F", "2Sh", "1R", "Sp", "-"],
    "01065": ["1F", "1Dr", "1Dc", "1R", "Sp", "-"],
    "01066": ["+2RD", "+3RD", "1Dr", "2Sh", "Sp", "-"],
    "01067": ["1Dc", "2Dc", "1R", "Sp", "Sp1", "-"],
    "02001": ["1RD", "1RD", "2RD", "+2RD", "1Dr", "-"],
    "02003": ["2RD", "1F", "2Dr", "2Dc", "1R", "-"],
    "02011": ["2RD", "3RD", "2Dc", "2Sh", "1R", "-"],
    "02014": ["2RD", "3RD1", "4RD1", "Sp", "Sp", "-"],
    "02044": ["2RD", "2RD", "1Dc", "2Dc", "1R", "-"]
]
