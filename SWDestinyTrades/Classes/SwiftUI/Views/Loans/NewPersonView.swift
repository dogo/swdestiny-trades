//
//  NewPersonView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct NewPersonView: View {

    @StateObject private var viewModel = NewPersonViewModel()
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FormField?
    @State private var showToast = false

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("First Name", text: $viewModel.firstName)
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
                            .foregroundColor(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    TextField("Last Name", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                        .focused($focusedField, equals: .lastName)
                        .onSubmit {
                            if viewModel.isFormValid {
                                viewModel.savePerson()
                            }
                        }

                    if let errorMessage = viewModel.getValidationMessage(for: .lastName) {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            } header: {
                Text(L10n.personInformation)
            } footer: {
                Text(L10n.enterThePersonsNameToTrackLoansWithThem)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section {
                Button(action: {
                    viewModel.savePerson()
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(L10n.done) {
                    viewModel.savePerson()
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
            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { newValue in
            showToast = newValue
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .firstName
            }
        }
    }
}

// MARK: - Previews

struct NewPersonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewPersonView()
        }
        .previewDisplayName("New Person - Light")

        NavigationView {
            NewPersonView()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("New Person - Dark")
    }
}
