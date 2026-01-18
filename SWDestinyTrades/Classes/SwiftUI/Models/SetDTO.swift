//
//  SetDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class SetDTO: Object, Codable, Storable, Identifiable {
    @Persisted var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted(primaryKey: true) var code: String = ""

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
}
