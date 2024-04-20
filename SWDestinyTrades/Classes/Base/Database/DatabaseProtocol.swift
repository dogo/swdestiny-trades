//
//  DatabaseProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 08/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

protocol Storable {}

struct Sorted {
    var key: String
    var ascending: Bool = true
}

protocol DatabaseProtocol: AnyObject {
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws

    func save(object: Storable, completion: (() -> Void)?) throws

    func update(block: @escaping () -> Void) throws

    func delete(object: Storable) throws

    func deleteAll<T: Storable>(_ model: T.Type) throws

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: ([T]) -> Void) throws

    func reset() throws
}
