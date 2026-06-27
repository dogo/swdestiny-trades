//
//  LoanDetailViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class LoanDetailViewModelTests: BaseTestCase {

    private var sut: LoanDetailViewModel!
    private var person: PersonDTO!

    override func setUp() async throws {
        try await super.setUp()
        person = PersonDTO.stub(
            name: "Luke",
            lastName: "Skywalker",
            lentMe: [CardDTO.stub(code: "01001", name: "Captain Phasma")],
            borrowed: [CardDTO.stub(code: "01002", name: "Kylo Ren")]
        )
        try await populateTestData(objects: [person])

        sut = LoanDetailViewModel(dependencyContainer: testContainer.container)
        sut.person = person
        await sut.loadLoanData()
    }

    override func tearDown() async throws {
        sut = nil
        person = nil
        try await super.tearDown()
    }

    // MARK: - Load

    func test_loadLoanData_populatesLentAndBorrowed() {
        XCTAssertEqual(sut.lentCards.map(\.code), ["01001"])
        XCTAssertEqual(sut.borrowedCards.map(\.code), ["01002"])
    }

    // MARK: - Derived state

    func test_personFullName_formatsGivenAndFamilyName() {
        XCTAssertTrue(sut.personFullName.contains("Luke"))
        XCTAssertTrue(sut.personFullName.contains("Skywalker"))
    }

    func test_hasLoans_trueWhenLoansPresent() {
        XCTAssertTrue(sut.hasLoans)
    }

    func test_hasLoans_falseWhenNoLoans() async {
        let emptyPerson = PersonDTO.stub(name: "Empty", lastName: "Person")
        try? await populateTestData(objects: [emptyPerson])
        sut.person = emptyPerson
        await sut.loadLoanData()

        XCTAssertFalse(sut.hasLoans)
    }

    func test_loanSummary_countsLentAndBorrowed() {
        XCTAssertEqual(sut.loanSummary.lentCount, 1)
        XCTAssertEqual(sut.loanSummary.borrowedCount, 1)
    }

    // MARK: - Delete confirmation flow (synchronous state)

    func test_prepareToDelete_setsCardAndShowsConfirmation() {
        let card = sut.lentCards[0]

        sut.prepareToDelete(card, type: .lent)

        XCTAssertTrue(sut.showingDeleteConfirmation)
        XCTAssertEqual(sut.cardToDelete?.card.code, "01001")
        XCTAssertEqual(sut.cardToDelete?.type, .lent)
    }

    func test_cancelDelete_clearsState() {
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.cancelDelete()

        XCTAssertFalse(sut.showingDeleteConfirmation)
        XCTAssertNil(sut.cardToDelete)
    }

    // MARK: - Confirm delete (async Task)

    func test_confirmDelete_lent_removesCardAndDismisses() async {
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.confirmDelete()
        await waitUntil { self.sut.showingDeleteConfirmation == false }

        XCTAssertTrue(sut.lentCards.isEmpty)
        XCTAssertNil(sut.cardToDelete)
    }

    func test_confirmDelete_borrow_removesCard() async {
        sut.prepareToDelete(sut.borrowedCards[0], type: .borrow)

        sut.confirmDelete()
        await waitUntil { self.sut.showingDeleteConfirmation == false }

        XCTAssertTrue(sut.borrowedCards.isEmpty)
    }

    func test_confirmDelete_withoutSelection_isNoOp() {
        sut.confirmDelete()

        XCTAssertFalse(sut.lentCards.isEmpty)
        XCTAssertFalse(sut.borrowedCards.isEmpty)
    }

    func test_confirmDelete_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.confirmDelete()
        await waitUntil { self.sut.toastQueue.current != nil }

        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    // MARK: - Update quantity (async Task)

    func test_updateCardQuantity_persistsNewQuantity() async {
        let card = sut.lentCards[0]

        sut.updateCardQuantity(card, newQuantity: 5)
        await waitUntil { self.sut.lentCards.first?.quantity == 5 }

        XCTAssertEqual(sut.lentCards.first?.quantity, 5)
    }

    // MARK: - Helpers

    /// Polls a condition for fire-and-forget `Task`-based view model methods.
    private func waitUntil(timeout: TimeInterval = 2.0, _ condition: @MainActor () -> Bool) async {
        let start = Date()
        while !condition() {
            if Date().timeIntervalSince(start) >= timeout { return }
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }
    }
}
