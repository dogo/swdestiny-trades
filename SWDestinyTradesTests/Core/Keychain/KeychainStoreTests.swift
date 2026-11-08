//
//  KeychainStoreTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class KeychainStoreTests {

    private let sut = KeychainStore(service: "KeychainStoreTests.\(UUID().uuidString)")

    isolated deinit {
        sut.delete("token")
        sut.delete("other")
    }

    @Test
    func data_missingKey_returnsNil() {
        #expect(sut.data(for: "token") == nil)
    }

    @Test
    func set_thenData_returnsStoredValue() {
        #expect(sut.set(Data("secret".utf8), for: "token"))
        #expect(sut.data(for: "token") == Data("secret".utf8))
    }

    @Test
    func set_existingKey_overwritesValue() {
        sut.set(Data("old".utf8), for: "token")
        #expect(sut.set(Data("new".utf8), for: "token"))
        #expect(sut.data(for: "token") == Data("new".utf8))
    }

    @Test
    func delete_removesOnlyThatKey() {
        sut.set(Data("a".utf8), for: "token")
        sut.set(Data("b".utf8), for: "other")

        sut.delete("token")

        #expect(sut.data(for: "token") == nil)
        #expect(sut.data(for: "other") == Data("b".utf8))
    }

    @Test
    func differentServices_doNotShareKeys() {
        let other = KeychainStore(service: "KeychainStoreTests.\(UUID().uuidString)")
        sut.set(Data("a".utf8), for: "token")

        #expect(other.data(for: "token") == nil)
    }
}
