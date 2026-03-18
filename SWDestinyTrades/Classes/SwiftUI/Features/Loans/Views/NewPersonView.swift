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
            NewPersonFormContent(viewModel: viewModel, focusedField: $focusedField)
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
