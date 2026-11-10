//
//  SaveDeckEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 10/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct SaveDeckEndpoint: EndpointProtocol {
    let remoteID: Int
    let bodyParameters: BodyParameters?

    init(remoteID: Int, deck: DeckDTO) throws {
        self.remoteID = remoteID
        var slots: [String: RemoteDeckDTO.Slot] = [:]
        for card in deck.list {
            let dice = card.hasDie ? card.quantity * (card.isElite ? 2 : 1) : 0
            slots[card.code] = RemoteDeckDTO.Slot(quantity: card.quantity, dice: dice)
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let slotsJSON = try String(bytes: encoder.encode(slots), encoding: .utf8) ?? ""
        let affiliationCode = deck.list.map(\.affiliationCode).first { $0 == "hero" || $0 == "villain" } ?? "neutral"
        bodyParameters = [
            "name": deck.name,
            "affiliation_code": affiliationCode,
            "slots": slotsJSON
        ]
    }

    var path: String {
        "/api/deck/save/\(remoteID)"
    }

    var method: HttpMethod {
        .put
    }

    var headers: HttpHeaders? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }

    var needsToken: Bool {
        true
    }
}
