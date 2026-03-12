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
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FormField?

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    TextField(L10n.firstName, text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
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

                VStack(alignment: .leading, spacing: 8) {
                    TextField(L10n.lastName, text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
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
            } header: {
                Text(L10n.personInformation)
            } footer: {
                Text(L10n.enterThePersonsNameToTrackLoansWithThem)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.done) {
                    Task {
                        await viewModel.savePerson()
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
            }
        }
        .overlay(alignment: .top) {
            if viewModel.showSuccessToast {
                ToastView(
                    title: L10n.added,
                    message: viewModel.addedPersonName,
                    type: .success,
                    isPresented: $viewModel.showSuccessToast
                ) {
                    dismiss()
                }
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .overlay(alignment: .top) {
            if viewModel.showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $viewModel.showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: viewModel.firstName) { _, _ in
            viewModel.validate()
        }
        .onChange(of: viewModel.lastName) { _, _ in
            viewModel.validate()
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                focusedField = .firstName
            }
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
