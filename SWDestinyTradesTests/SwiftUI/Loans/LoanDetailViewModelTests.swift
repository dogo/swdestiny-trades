//
//  LoanDetailViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class LoanDetailViewModelTests: BaseTestCase {

    private var sut: LoanDetailViewModel!
    private var person: PersonDTO!

    override init() async throws {
        try await super.init()
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

    deinit {
        sut = nil
        person = nil
    }

    // MARK: - Load

    @Test
    func test_loadLoanData_populatesLentAndBorrowed() {
        #expect(sut.lentCards.map(\.code) == ["01001"])
        #expect(sut.borrowedCards.map(\.code) == ["01002"])
    }

    // MARK: - Derived state

    @Test
    func test_personFullName_formatsGivenAndFamilyName() {
        #expect(sut.personFullName.contains("Luke"))
        #expect(sut.personFullName.contains("Skywalker"))
    }

    @Test
    func test_hasLoans_trueWhenLoansPresent() {
        #expect(sut.hasLoans)
    }

    @Test
    func test_hasLoans_falseWhenNoLoans() async {
        let emptyPerson = PersonDTO.stub(name: "Empty", lastName: "Person")
        try? await populateTestData(objects: [emptyPerson])
        sut.person = emptyPerson
        await sut.loadLoanData()

        #expect(sut.hasLoans == false)
    }

    @Test
    func test_loanSummary_countsLentAndBorrowed() {
        #expect(sut.loanSummary.lentCount == 1)
        #expect(sut.loanSummary.borrowedCount == 1)
    }

    // MARK: - Delete confirmation flow (synchronous state)

    @Test
    func test_prepareToDelete_setsCardAndShowsConfirmation() {
        let card = sut.lentCards[0]

        sut.prepareToDelete(card, type: .lent)

        #expect(sut.showingDeleteConfirmation)
        #expect(sut.cardToDelete?.card.code == "01001")
        #expect(sut.cardToDelete?.type == .lent)
    }

    @Test
    func test_cancelDelete_clearsState() {
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.cancelDelete()

        #expect(sut.showingDeleteConfirmation == false)
        #expect(sut.cardToDelete == nil)
    }

    // MARK: - Confirm delete (async Task)

    @Test
    func test_confirmDelete_lent_removesCardAndDismisses() async {
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.confirmDelete()
        await waitUntil { self.sut.showingDeleteConfirmation == false }

        #expect(sut.lentCards.isEmpty)
        #expect(sut.cardToDelete == nil)
    }

    @Test
    func test_confirmDelete_borrow_removesCard() async {
        sut.prepareToDelete(sut.borrowedCards[0], type: .borrow)

        sut.confirmDelete()
        await waitUntil { self.sut.showingDeleteConfirmation == false }

        #expect(sut.borrowedCards.isEmpty)
    }

    @Test
    func test_confirmDelete_withoutSelection_isNoOp() {
        sut.confirmDelete()

        #expect(sut.lentCards.isEmpty == false)
        #expect(sut.borrowedCards.isEmpty == false)
    }

    @Test
    func test_confirmDelete_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        sut.prepareToDelete(sut.lentCards[0], type: .lent)

        sut.confirmDelete()
        await waitUntil { self.sut.toastQueue.current != nil }

        #expect(sut.toastQueue.current?.type == .error)
    }

    // MARK: - Update quantity (async Task)

    @Test
    func test_updateCardQuantity_persistsNewQuantity() async {
        let card = sut.lentCards[0]

        sut.updateCardQuantity(card, newQuantity: 5)
        await waitUntil { self.sut.lentCards.first?.quantity == 5 }

        #expect(sut.lentCards.first?.quantity == 5)
    }
}
