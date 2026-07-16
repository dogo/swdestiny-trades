//
//  PeopleListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class PeopleListViewModelTests: BaseTestCase {

    private var sut: PeopleListViewModel!

    override init() async throws {
        try await super.init()
        sut = PeopleListViewModel(dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
    }

    // MARK: - Load

    @Test
    func loadPeople_populatesItemsFromDatabase() async {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        try? await populateTestData(objects: [luke, leia])

        await sut.loadPeople()
        _ = await waitForLoadingToComplete(viewModel: sut)

        #expect(sut.items.count == 2)
        #expect(sut.isLoading == false)
    }

    // MARK: - Filtering

    @Test
    func filterItems_byFirstName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        sut.updateItems([luke, leia])

        sut.performFiltering(searchText: "Luke")

        #expect(sut.filteredItems.map(\.name) == ["Luke"])
    }

    @Test
    func filterItems_byLastName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        sut.updateItems([luke, leia])

        sut.performFiltering(searchText: "Organa")

        #expect(sut.filteredItems.map(\.name) == ["Leia"])
    }

    @Test
    func filterItems_emptySearch_returnsAllSortedByName() {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let anakin = PersonDTO.stub(name: "Anakin", lastName: "Skywalker")
        sut.updateItems([luke, anakin])

        sut.performFiltering(searchText: "")

        #expect(sut.filteredItems.map(\.name) == ["Anakin", "Luke"])
    }

    // MARK: - Delete

    @Test
    func deletePerson_removesPersonAndEnqueuesSuccessToast() async {
        let luke = PersonDTO.stub(name: "Luke", lastName: "Skywalker")
        let leia = PersonDTO.stub(name: "Leia", lastName: "Organa")
        try? await populateTestData(objects: [luke, leia])
        sut.updateItems([luke, leia])

        await sut.deletePerson(luke)

        #expect(sut.items.map(\.id) == [leia.id])
        #expect(sut.toastQueue.current?.type == .success)
    }

    // MARK: - Loan summary

    @Test
    func getLoanSummary_sumsCardQuantities() {
        let person = PersonDTO.stub(
            name: "Han",
            lastName: "Solo",
            lentMe: [CardDTO.stub(code: "01001", quantity: 3)],
            borrowed: [CardDTO.stub(code: "01002", quantity: 2)]
        )

        let summary = sut.getLoanSummary(for: person)

        #expect(summary.lentCount == 3)
        #expect(summary.borrowedCount == 2)
        #expect(summary.hasLoans)
    }

    @Test
    func getLoanSummary_noLoans_hasLoansIsFalse() {
        let person = PersonDTO.stub(name: "Empty", lastName: "Person")

        let summary = sut.getLoanSummary(for: person)

        #expect(summary.lentCount == 0)
        #expect(summary.borrowedCount == 0)
        #expect(summary.hasLoans == false)
    }
}
