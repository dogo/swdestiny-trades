//
//  RealmManager.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 19/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager: NSObject {

    static let shared = RealmManager()

// swiftlint:disable force_try
#if targetEnvironment(simulator)
    let realm = try! Realm(fileURL: URL(fileURLWithPath: "\(RealmManager.realHomeDirectory())/Desktop/default.realm"))
#else
    let realm = try! Realm()
#endif
// swiftlint:enable force_try

    override private init () {}

    func performInBackground(_ backgroundAction: @escaping (_ backgroundRealm: Realm) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let backgroundRealm = try Realm()
                backgroundAction(backgroundRealm)
            } catch let error as NSError {
                fatalError("Error opening realm: \(error)")
            }
        }
    }

    private static func realHomeDirectory() -> String {
        let homeDirectory = NSHomeDirectory()
        let pathComponents = homeDirectory.components(separatedBy: "/")
        return "/\(pathComponents[1])/\(pathComponents[2])"
    }
}
