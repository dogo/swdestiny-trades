//
//  NewPersonFormContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct NewPersonFormContent: View {
    @Bindable var viewModel: NewPersonViewModel
    var focusedField: FocusState<FormField?>.Binding

    var body: some View {
        Section {
            PersonFormField(
                label: L10n.firstName,
                text: $viewModel.firstName,
                focus: focusedField,
                field: .firstName,
                errorMessage: viewModel.getValidationMessage(for: .firstName)
            ) {
                focusedField.wrappedValue = .lastName
            }
            PersonFormField(
                label: L10n.lastName,
                text: $viewModel.lastName,
                focus: focusedField,
                field: .lastName,
                errorMessage: viewModel.getValidationMessage(for: .lastName)
            ) {
                if viewModel.isFormValid {
                    Task { await viewModel.savePerson() }
                }
            }
        } header: {
            Text(L10n.personInformation)
        } footer: {
            Text(L10n.enterThePersonsNameToTrackLoansWithThem)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        SavePersonSection(
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid || viewModel.isLoading
        ) {
            Task { await viewModel.savePerson() }
        }
    }
}
