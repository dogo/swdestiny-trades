//
//  SaveDeckResponseDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 10/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

nonisolated struct SaveDeckResponseDTO: Decodable {
    let success: Bool
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case success
        case message = "msg"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        message = try? container.decode(String.self, forKey: .message)
    }
}

enum SaveDeckError: LocalizedError, Equatable {
    case rejected(String?)

    var errorDescription: String? {
        switch self {
        case let .rejected(message):
            return message
        }
    }
}
