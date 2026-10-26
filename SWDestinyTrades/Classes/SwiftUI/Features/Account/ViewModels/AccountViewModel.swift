//
//  AccountViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AuthenticationServices
import Observation

@MainActor
@Observable
final class AccountViewModel: BaseViewModel {

    typealias Authenticate = (_ url: URL, _ callbackScheme: String) async throws -> URL

    private(set) var isLoggedIn = false

    private var authService: AuthServiceProtocol {
        dependencyContainer.resolve(type: AuthServiceProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    func refresh() {
        isLoggedIn = authService.isLoggedIn
    }

    func login(authenticate: Authenticate) async {
        clearError()
        setLoading(true)
        defer { setLoading(false) }

        do {
            let url = try authService.authorizationURL()
            let callbackURL = try await authenticate(url, AuthEndpoint.callbackScheme)
            try await authService.completeLogin(callbackURL: callbackURL)
            isLoggedIn = true
        } catch ASWebAuthenticationSessionError.canceledLogin {
            return
        } catch {
            handleError(error)
        }
    }

    func logout() {
        authService.logout()
        isLoggedIn = false
    }
}
