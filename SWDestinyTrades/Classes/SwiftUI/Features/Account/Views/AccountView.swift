//
//  AccountView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AuthenticationServices
import SwiftUI

struct AccountView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var viewModel: AccountViewModel

    init(viewModel: AccountViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? AccountViewModel())
    }

    var body: some View {
        List {
            Section {
                Label(viewModel.isLoggedIn ? L10n.accountConnected : L10n.accountDisconnected,
                      systemImage: viewModel.isLoggedIn ? "checkmark.circle.fill" : "person.crop.circle")
            } footer: {
                Text(L10n.accountDescription)
            }

            Section {
                if viewModel.isLoggedIn {
                    Button(L10n.signOut, role: .destructive, action: viewModel.logout)
                } else {
                    Button(action: login) {
                        HStack {
                            Text(L10n.signInArh)
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .navigationTitle(L10n.account)
        .navigationBarTitleDisplayMode(.inline)
        .toastQueue(viewModel.toastQueue)
        .onAppear(perform: viewModel.refresh)
    }

    private func login() {
        Task {
            await viewModel.login { url, callbackScheme in
                try await webAuthenticationSession.authenticate(using: url,
                                                                callbackURLScheme: callbackScheme,
                                                                preferredBrowserSession: .ephemeral)
            }
        }
    }
}

#Preview {
    DependencyContainer.shared.register(type: AuthServiceProtocol.self) {
        AuthService(client: PreviewHttpClientMock())
    }
    return NavigationStack {
        AccountView()
    }
}
