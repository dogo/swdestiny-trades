//
//  RealmManager.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 19/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import RealmSwift

final class RealmManager: NSObject {

    static let shared = RealmManager()

#if (arch(i386) || arch(x86_64)) && os(iOS)
    let realm = try! Realm(fileURL: URL(fileURLWithPath: "/Users/diogoautilio/Desktop/TestRealm.realm"))
#else
    let realm = try! Realm()
#endif

    func performInBackground(_ backgroundAction: @escaping (_ backgroundRealm: Realm) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let backgroundRealm = try! Realm()
            backgroundAction(backgroundRealm)
        }
    }
}
