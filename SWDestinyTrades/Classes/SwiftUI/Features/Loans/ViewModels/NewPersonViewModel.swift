//
//  NewPersonViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class NewPersonViewModel: BaseViewModel {

    var firstName = ""
    var lastName = ""
    var isFormValid = false
    var showSuccessToast = false
    var addedPersonName = ""
    var validationErrors: [ValidationError] = []

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    func validate() {
        isFormValid = validateForm(firstName: firstName, lastName: lastName)
    }

    private func validateForm(firstName: String, lastName: String) -> Bool {
        validationErrors.removeAll()

        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append(.emptyFirstName)
        } else if firstName.count < 2 {
            validationErrors.append(.firstNameTooShort)
        }

        if !lastName.isEmpty, lastName.count < 2 {
            validationErrors.append(.lastNameTooShort)
        }

        return validationErrors.isEmpty
    }

    func savePerson() async {
        guard isFormValid else {
            return
        }

        setLoading(true)
        defer { setLoading(false) }

        let person = PersonDTO()
        person.name = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        person.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try Task.checkCancellation()

            try await database.save(object: person, update: .modified)

            try Task.checkCancellation()

            addedPersonName = "\(person.name) \(person.lastName)".trimmingCharacters(in: .whitespaces)
            showSuccessToast = true
            resetForm()
        } catch is CancellationError {
            // Silently cancel
        } catch {
            handleError(error)
        }
    }

    func resetForm() {
        firstName = ""
        lastName = ""
        validationErrors.removeAll()
    }

    func hasValidationError(_ error: ValidationError) -> Bool {
        return validationErrors.contains(error)
    }

    func getValidationMessage(for field: FormField) -> String? {
        switch field {
        case .firstName:
            if hasValidationError(.emptyFirstName) {
                return L10n.firstNameRequired
            } else if hasValidationError(.firstNameTooShort) {
                return L10n.firstNameMinLength
            }
        case .lastName:
            if hasValidationError(.lastNameTooShort) {
                return L10n.lastNameMinLength
            }
        }
        return nil
    }

    override func handleError(_ error: Error) {
        setLoading(false)

        toastTitle = L10n.error
        toastMessage = error.localizedDescription
        toastType = .error
        showToast = true
    }
}

enum ValidationError: Equatable {
    case emptyFirstName
    case firstNameTooShort
    case lastNameTooShort
}

enum FormField {
    case firstName
    case lastName
}
