//
//  RealmDatabase.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 08/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmDatabaseError: Error {
    case invalidMemory(identifier: String?)
    case objectCouldNotBeParsed
}

enum ConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)

    var associated: String? {
        switch self {
        case .basic(let url):
            return url
        case .inMemory(let identifier):
            return identifier
        }
    }
}

final class RealmDatabase: DatabaseProtocol {

    let realm: Realm

    convenience init() throws {
#if targetEnvironment(simulator)
        let configuration = ConfigurationType.basic(url: "\(RealmDatabase.realHomeDirectory())/Desktop/default.realm")
        try self.init(configuration: configuration)
#else
        try self.init(configuration: .basic(url: nil))
#endif
    }

    required init(configuration: ConfigurationType = .basic(url: nil)) throws {

        var rmConfig = Realm.Configuration()
        rmConfig.readOnly = true

        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = URL(string: url)
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw RealmDatabaseError.invalidMemory(identifier: configuration.associated)
            }
        }
        rmConfig.schemaVersion = RealmMigrations.schemaVersion
        try self.realm = Realm(configuration: rmConfig)
    }

    func writeSafely(_ block: (() throws -> Void)) throws {
        if realm.isInWriteTransaction {
            try block()
        } else {
            try self.realm.write(block)
        }
    }

    static func realHomeDirectory() -> String {
        let homeDirectory = NSHomeDirectory()
        let pathComponents = homeDirectory.components(separatedBy: "/")
        return "/\(pathComponents[1])/\(pathComponents[2])"
    }
}
