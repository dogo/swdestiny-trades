//
//  NewPersonViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class NewPersonViewModel: BaseViewModel {

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var isFormValid = false
    @Published var showSuccessToast = false
    @Published var addedPersonName = ""
    @Published var validationErrors: [ValidationError] = []

    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        setupValidation()
    }

    private func setupValidation() {
        Publishers.CombineLatest($firstName, $lastName)
            .receive(on: DispatchQueue.main)
            .map { firstName, lastName in
                self.validateForm(firstName: firstName, lastName: lastName)
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
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

        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        setLoading(true)
        defer { setLoading(false) }

        let person = PersonDTO()
        person.name = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        person.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try await database.save(object: person, update: .modified)

            addedPersonName = "\(person.name) \(person.lastName)".trimmingCharacters(in: .whitespaces)
            showSuccessToast = true
            resetForm()

            NotificationCenter.default.post(name: .personAdded, object: person)
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
                return "First name is required"
            } else if hasValidationError(.firstNameTooShort) {
                return "First name must be at least 2 characters"
            }
        case .lastName:
            if hasValidationError(.lastNameTooShort) {
                return "Last name must be at least 2 characters"
            }
        }
        return nil
    }

    override func handleError(_ error: Error) {
        setLoading(false)
        showToast = false

        toastTitle = "Error"
        toastMessage = error.localizedDescription
        toastType = .error

        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
            } catch {
                // Ignore cancellation during toast delay
            }
        }
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
