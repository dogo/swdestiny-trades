//
//  PeopleListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class PeopleListViewModelTests: BaseTestCase {

    private var sut: PeopleListViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = PeopleListViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Load

    func test_loadPeople_populatesItemsFromDatabase() async {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        try? await populateTestData(objects: [luke, leia])

        await sut.loadPeople()
        _ = await waitForLoadingToComplete(viewModel: sut)

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Filtering

    func test_filterItems_byFirstName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        sut.updateItems([luke, leia])

        sut.performFiltering(searchText: "Luke")

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Luke"])
    }

    func test_filterItems_byLastName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        sut.updateItems([luke, leia])

        sut.performFiltering(searchText: "Organa")

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Leia"])
    }

    func test_filterItems_emptySearch_returnsAllSortedByName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let anakin = PersonDTO.stub(name: "Anakin", lastName: "Skywalker")
        sut.updateItems([luke, anakin])

        sut.performFiltering(searchText: "")

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Anakin", "Luke"])
    }

    // MARK: - Delete

    func test_deletePerson_removesPersonAndEnqueuesSuccessToast() async {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        try? await populateTestData(objects: [luke, leia])
        sut.updateItems([luke, leia])

        await sut.deletePerson(luke)

        XCTAssertEqual(sut.items.map(\.id), [leia.id])
        XCTAssertEqual(sut.toastQueue.current?.type, .success)
    }

    // MARK: - Loan summary

    func test_getLoanSummary_sumsCardQuantities() {
        let person = PersonDTO.stub(
            name: "Han",
            lastName: "Solo",
            lentMe: [CardDTO.stub(code: "01001", quantity: 3)],
            borrowed: [CardDTO.stub(code: "01002", quantity: 2)]
        )

        let summary = sut.getLoanSummary(for: person)

        XCTAssertEqual(summary.lentCount, 3)
        XCTAssertEqual(summary.borrowedCount, 2)
        XCTAssertTrue(summary.hasLoans)
    }

    func test_getLoanSummary_noLoans_hasLoansIsFalse() {
        let person = PersonDTO.stub(name: "Empty", lastName: "Person")

        let summary = sut.getLoanSummary(for: person)

        XCTAssertEqual(summary.lentCount, 0)
        XCTAssertEqual(summary.borrowedCount, 0)
        XCTAssertFalse(summary.hasLoans)
    }
}
