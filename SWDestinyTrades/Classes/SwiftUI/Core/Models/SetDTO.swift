//
//  SetDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation

class SetDTO: Codable, Storable, Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""
    var code: String = ""

    init() {}

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case name, code
    }

    required init(from decoder: Decoder) throws {
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

extension SetDTO: Equatable {
    static func == (lhs: SetDTO, rhs: SetDTO) -> Bool {
        lhs.code == rhs.code
    }
}

extension SetDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
