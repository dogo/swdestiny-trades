//
//  NewPersonViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class NewPersonViewModelTests: BaseTestCase {

    private var sut: NewPersonViewModel!

    override init() async throws {
        try await super.init()
        sut = NewPersonViewModel(dependencyContainer: testContainer.container)
    }

    deinit {
        sut = nil
    }

    // MARK: - Validation

    @Test
    func test_validate_emptyFirstName_isInvalid() {
        sut.firstName = ""

        sut.validate()

        #expect(sut.isFormValid == false)
        #expect(sut.hasValidationError(.emptyFirstName))
    }

    @Test
    func test_validate_whitespaceFirstName_isInvalid() {
        sut.firstName = "   "

        sut.validate()

        #expect(sut.isFormValid == false)
        #expect(sut.hasValidationError(.emptyFirstName))
    }

    @Test
    func test_validate_shortFirstName_isInvalid() {
        sut.firstName = "A"

        sut.validate()

        #expect(sut.isFormValid == false)
        #expect(sut.hasValidationError(.firstNameTooShort))
    }

    @Test
    func test_validate_shortLastName_isInvalid() {
        sut.firstName = "Luke"
        sut.lastName = "S"

        sut.validate()

        #expect(sut.isFormValid == false)
        #expect(sut.hasValidationError(.lastNameTooShort))
    }

    @Test
    func test_validate_validFirstNameEmptyLastName_isValid() {
        sut.firstName = "Luke"
        sut.lastName = ""

        sut.validate()

        #expect(sut.isFormValid)
        #expect(sut.validationErrors.isEmpty)
    }

    @Test
    func test_validate_validFirstAndLastName_isValid() {
        sut.firstName = "Luke"
        sut.lastName = "Skywalker"

        sut.validate()

        #expect(sut.isFormValid)
    }

    // MARK: - Validation messages

    @Test
    func test_getValidationMessage_emptyFirstName() {
        sut.firstName = ""
        sut.validate()

        #expect(sut.getValidationMessage(for: .firstName) == L10n.firstNameRequired)
    }

    @Test
    func test_getValidationMessage_shortFirstName() {
        sut.firstName = "A"
        sut.validate()

        #expect(sut.getValidationMessage(for: .firstName) == L10n.firstNameMinLength)
    }

    @Test
    func test_getValidationMessage_shortLastName() {
        sut.firstName = "Luke"
        sut.lastName = "S"
        sut.validate()

        #expect(sut.getValidationMessage(for: .lastName) == L10n.lastNameMinLength)
    }

    @Test
    func test_getValidationMessage_noError_returnsNil() {
        sut.firstName = "Luke"
        sut.lastName = "Skywalker"
        sut.validate()

        #expect(sut.getValidationMessage(for: .firstName) == nil)
        #expect(sut.getValidationMessage(for: .lastName) == nil)
    }

    // MARK: - Save

    @Test
    func test_savePerson_whenInvalid_doesNotPersist() async {
        sut.firstName = ""
        sut.validate()

        await sut.savePerson()

        let people = await testDatabase.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        #expect(people.isEmpty)
        #expect(sut.isSaved == false)
    }

    @Test
    func test_savePerson_valid_persistsTrimmedNamesAndShowsSuccess() async {
        sut.firstName = "  Han  "
        sut.lastName = "  Solo  "
        sut.validate()

        await sut.savePerson()

        let people = await testDatabase.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        #expect(people.count == 1)
        #expect(people.first?.name == "Han")
        #expect(people.first?.lastName == "Solo")
        #expect(sut.isSaved)
        #expect(sut.isFormValid == false)
        #expect(sut.isLoading == false)
        #expect(sut.toastQueue.current?.type == .success)
    }

    @Test
    func test_savePerson_successToastDismiss_setsShouldDismiss() async {
        sut.firstName = "Han"
        sut.lastName = "Solo"
        sut.validate()
        await sut.savePerson()

        // Dismissing the success toast triggers the onDismiss callback.
        sut.toastQueue.advance()
        await waitUntil { self.sut.shouldDismiss }

        #expect(sut.shouldDismiss)
    }

    @Test
    func test_savePerson_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        sut.firstName = "Han"
        sut.lastName = "Solo"
        sut.validate()

        await sut.savePerson()

        #expect(sut.isSaved == false)
        #expect(sut.isLoading == false)
        #expect(sut.toastQueue.current?.type == .error)
    }
}
