//
//  NewPersonViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class NewPersonViewModelTests: BaseTestCase {

    private var sut: NewPersonViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = NewPersonViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Validation

    func test_validate_emptyFirstName_isInvalid() {
        sut.firstName = ""

        sut.validate()

        XCTAssertFalse(sut.isFormValid)
        XCTAssertTrue(sut.hasValidationError(.emptyFirstName))
    }

    func test_validate_whitespaceFirstName_isInvalid() {
        sut.firstName = "   "

        sut.validate()

        XCTAssertFalse(sut.isFormValid)
        XCTAssertTrue(sut.hasValidationError(.emptyFirstName))
    }

    func test_validate_shortFirstName_isInvalid() {
        sut.firstName = "A"

        sut.validate()

        XCTAssertFalse(sut.isFormValid)
        XCTAssertTrue(sut.hasValidationError(.firstNameTooShort))
    }

    func test_validate_shortLastName_isInvalid() {
        sut.firstName = "Luke"
        sut.lastName = "S"

        sut.validate()

        XCTAssertFalse(sut.isFormValid)
        XCTAssertTrue(sut.hasValidationError(.lastNameTooShort))
    }

    func test_validate_validFirstNameEmptyLastName_isValid() {
        sut.firstName = "Luke"
        sut.lastName = ""

        sut.validate()

        XCTAssertTrue(sut.isFormValid)
        XCTAssertTrue(sut.validationErrors.isEmpty)
    }

    func test_validate_validFirstAndLastName_isValid() {
        sut.firstName = "Luke"
        sut.lastName = "Skywalker"

        sut.validate()

        XCTAssertTrue(sut.isFormValid)
    }

    // MARK: - Validation messages

    func test_getValidationMessage_emptyFirstName() {
        sut.firstName = ""
        sut.validate()

        XCTAssertEqual(sut.getValidationMessage(for: .firstName), L10n.firstNameRequired)
    }

    func test_getValidationMessage_shortFirstName() {
        sut.firstName = "A"
        sut.validate()

        XCTAssertEqual(sut.getValidationMessage(for: .firstName), L10n.firstNameMinLength)
    }

    func test_getValidationMessage_shortLastName() {
        sut.firstName = "Luke"
        sut.lastName = "S"
        sut.validate()

        XCTAssertEqual(sut.getValidationMessage(for: .lastName), L10n.lastNameMinLength)
    }

    func test_getValidationMessage_noError_returnsNil() {
        sut.firstName = "Luke"
        sut.lastName = "Skywalker"
        sut.validate()

        XCTAssertNil(sut.getValidationMessage(for: .firstName))
        XCTAssertNil(sut.getValidationMessage(for: .lastName))
    }

    // MARK: - Save

    func test_savePerson_whenInvalid_doesNotPersist() async {
        sut.firstName = ""
        sut.validate()

        await sut.savePerson()

        let people = await testDatabase.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        XCTAssertTrue(people.isEmpty)
        XCTAssertFalse(sut.isSaved)
    }

    func test_savePerson_valid_persistsTrimmedNamesAndShowsSuccess() async {
        sut.firstName = "  Han  "
        sut.lastName = "  Solo  "
        sut.validate()

        await sut.savePerson()

        let people = await testDatabase.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(people.count, 1)
        XCTAssertEqual(people.first?.name, "Han")
        XCTAssertEqual(people.first?.lastName, "Solo")
        XCTAssertTrue(sut.isSaved)
        XCTAssertFalse(sut.isFormValid)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.toastQueue.current?.type, .success)
    }

    func test_savePerson_successToastDismiss_setsShouldDismiss() async {
        sut.firstName = "Han"
        sut.lastName = "Solo"
        sut.validate()
        await sut.savePerson()

        // Dismissing the success toast triggers the onDismiss callback.
        sut.toastQueue.advance()
        await waitUntil { self.sut.shouldDismiss }

        XCTAssertTrue(sut.shouldDismiss)
    }

    func test_savePerson_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        sut.firstName = "Han"
        sut.lastName = "Solo"
        sut.validate()

        await sut.savePerson()

        XCTAssertFalse(sut.isSaved)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    // MARK: - Helpers

    private func waitUntil(timeout: TimeInterval = 2.0, _ condition: @MainActor () -> Bool) async {
        let start = Date()
        while !condition() {
            if Date().timeIntervalSince(start) >= timeout { return }
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }
    }
}
