//
//  SetsListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class SetsListViewModelTests: BaseTestCase {

    private var sut: SetsListViewModel!

    override init() async throws {
        try await super.init()
        sut = SetsListViewModel(dependencyContainer: testContainer.container)
    }

    deinit {
        sut = nil
    }

    // MARK: - Load

    @Test
    func test_loadItems_fetchesSetsAndPersistsThem() async {
        mockSWDestinyService.retrieveSetListResult = [
            SetDTO.stub(name: "Awakenings", code: "AW"),
            SetDTO.stub(name: "Spark of Hope", code: "SOH")
        ]

        await sut.loadItems()

        #expect(sut.items.count == 2)
        #expect(sut.isLoading == false)
        let persisted = await testDatabase.fetch(SetDTO.self, predicate: nil, sorted: nil)
        #expect(persisted.count == 2)
    }

    @Test
    func test_loadItems_onError_enqueuesErrorToast() async {
        mockSWDestinyService.retrieveSetListError = APIError.invalidData

        await sut.loadItems()

        #expect(sut.isLoading == false)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func test_refreshSets_updatesItems() async {
        mockSWDestinyService.retrieveSetListResult = [SetDTO.stub(name: "Awakenings", code: "AW")]

        await sut.refreshSets()

        #expect(sut.items.map(\.code) == ["AW"])
    }

    // MARK: - Filtering

    @Test
    func test_filterItems_byNameOrCode() {
        let awakenings = SetDTO.stub(name: "Awakenings", code: "AW")
        let soh = SetDTO.stub(name: "Spark of Hope", code: "SOH")
        sut.updateItems([awakenings, soh])

        sut.performFiltering(searchText: "Awak")
        #expect(sut.filteredItems.map(\.code) == ["AW"])

        sut.performFiltering(searchText: "SOH")
        #expect(sut.filteredItems.map(\.code) == ["SOH"])
    }

    @Test
    func test_filterItems_emptySearch_returnsAll() {
        sut.updateItems([SetDTO.stub(name: "Awakenings", code: "AW"), SetDTO.stub(name: "Spark of Hope", code: "SOH")])

        sut.performFiltering(searchText: "")

        #expect(sut.filteredItems.count == 2)
    }
}
