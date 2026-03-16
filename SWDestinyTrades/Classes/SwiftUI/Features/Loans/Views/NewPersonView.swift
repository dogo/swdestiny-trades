//
//  NewPersonView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct NewPersonView: View {

    @State private var viewModel = NewPersonViewModel()
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FormField?

    var body: some View {
        Form {
            Section {
                firstNameField
                lastNameField
            } header: {
                Text(L10n.personInformation)
            } footer: {
                Text(L10n.enterThePersonsNameToTrackLoansWithThem)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            saveButtonSection
        }
        .toolbar { toolbarContent }
        .toastQueue(viewModel.toastQueue)
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .onChange(of: viewModel.firstName) { _, _ in viewModel.validate() }
        .onChange(of: viewModel.lastName) { _, _ in viewModel.validate() }
        .onAppear {
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                focusedField = .firstName
            }
        }
    }

    private var firstNameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(L10n.firstName, text: $viewModel.firstName)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(false)
                .focused($focusedField, equals: .firstName)
                .onSubmit {
                    focusedField = .lastName
                }

            if let errorMessage = viewModel.getValidationMessage(for: .firstName) {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }

    private var lastNameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(L10n.lastName, text: $viewModel.lastName)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(false)
                .focused($focusedField, equals: .lastName)
                .onSubmit {
                    if viewModel.isFormValid {
                        Task {
                            await viewModel.savePerson()
                        }
                    }
                }

            if let errorMessage = viewModel.getValidationMessage(for: .lastName) {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }

    private var saveButtonSection: some View {
        Section {
            Button(action: {
                Task {
                    await viewModel.savePerson()
                }
            }, label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }

                    Text(L10n.savePerson)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
            })
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(L10n.done) {
                Task {
                    await viewModel.savePerson()
                }
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
        }
    }
}

// MARK: - Previews

#Preview("New Person - Light") {
    NavigationStack {
        NewPersonView()
    }
}

#Preview("New Person - Dark") {
    NavigationStack {
        NewPersonView()
    }
    .preferredColorScheme(.dark)
}
