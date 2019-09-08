//
//  RealmDatabase+Operations.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 08/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmDatabase {

    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws {
        guard let storable = model as? Object.Type else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try self.writeSafely { [weak self] in
            if let newObject = self?.realm.create(storable, value: [], update: .error) as? T {
                completion(newObject)
            }
        }
    }

    func save(object: Storable) throws {
        guard let storable = object as? Object else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try self.writeSafely { [weak self] in
            self?.realm.add(storable)
        }
    }

    func update(block: @escaping () -> Void) throws {
        try self.writeSafely {
            block()
        }
    }

    func delete(object: Storable) throws {
        guard let storable = object as? Object else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try self.writeSafely { [weak self] in
            self?.realm.delete(storable)
        }
    }

    func deleteAll<T: Storable>(_ model: T.Type) throws {
        guard let storable = model as? Object.Type else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try self.writeSafely { [weak self] in
            guard let self = self else { return }

            let objects = self.realm.objects(storable)

            _ = objects.compactMap { [weak self] in
                self?.realm.delete($0)
            }
        }
    }

    func reset() throws {
        try self.writeSafely { [weak self] in
            self?.realm.deleteAll()
        }
    }

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> Void)) throws {
        guard let storable = model as? Object.Type else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        var objects = self.realm.objects(storable)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }

        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }

        let storeables: [T] = objects.compactMap { $0 as? T }

        completion(storeables)
    }
}
