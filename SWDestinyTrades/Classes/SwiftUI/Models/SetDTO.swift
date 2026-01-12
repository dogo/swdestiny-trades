//
//  SetDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable attributes
class SetDTO: Object, Codable, Storable, Identifiable, @unchecked Sendable {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var code: String = ""

    override static func primaryKey() -> String? {
        return "code"
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case name, code
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
    }

    // MARK: - Hashable

    override var hash: Int {
        return code.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SetDTO else { return false }
        return code == other.code
    }
}

// swiftlint:enable attributes
