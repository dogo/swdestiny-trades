//
//  SetsListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class SetsListViewModelTests: BaseTestCase {

    private var sut: SetsListViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = SetsListViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Load

    func test_loadItems_fetchesSetsAndPersistsThem() async {
        mockSWDestinyService.retrieveSetListResult = [
            SetDTO.stub(name: "Awakenings", code: "AW"),
            SetDTO.stub(name: "Spark of Hope", code: "SOH")
        ]

        await sut.loadItems()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertFalse(sut.isLoading)
        let persisted = await testDatabase.fetch(SetDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(persisted.count, 2)
    }

    func test_loadItems_onError_enqueuesErrorToast() async {
        mockSWDestinyService.retrieveSetListError = APIError.invalidData

        await sut.loadItems()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    func test_refreshSets_updatesItems() async {
        mockSWDestinyService.retrieveSetListResult = [SetDTO.stub(name: "Awakenings", code: "AW")]

        await sut.refreshSets()

        XCTAssertEqual(sut.items.map(\.code), ["AW"])
    }

    // MARK: - Filtering

    func test_filterItems_byNameOrCode() {
        let aw = SetDTO.stub(name: "Awakenings", code: "AW")
        let soh = SetDTO.stub(name: "Spark of Hope", code: "SOH")
        sut.updateItems([aw, soh])

        sut.performFiltering(searchText: "Awak")
        XCTAssertEqual(sut.filteredItems.map(\.code), ["AW"])

        sut.performFiltering(searchText: "SOH")
        XCTAssertEqual(sut.filteredItems.map(\.code), ["SOH"])
    }

    func test_filterItems_emptySearch_returnsAll() {
        sut.updateItems([SetDTO.stub(name: "Awakenings", code: "AW"), SetDTO.stub(name: "Spark of Hope", code: "SOH")])

        sut.performFiltering(searchText: "")

        XCTAssertEqual(sut.filteredItems.count, 2)
    }
}
