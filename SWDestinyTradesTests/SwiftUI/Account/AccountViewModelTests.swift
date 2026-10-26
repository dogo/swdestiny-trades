//
//  AccountViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AuthenticationServices
import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class AccountViewModelTests: BaseTestCase {

    private var authService: AuthServiceMock!
    private var sut: AccountViewModel!

    override init() async throws {
        try await super.init()
        authService = AuthServiceMock()
        registerMock(AuthServiceProtocol.self) { [unowned self] in authService }
        sut = AccountViewModel(dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
        authService = nil
    }

    @Test
    func refresh_readsLoginState() {
        authService.isLoggedIn = true

        sut.refresh()

        #expect(sut.isLoggedIn)
    }

    @Test
    func login_passesCallbackToServiceAndLogsIn() async {
        let callback = URL(string: "swdestinytrades://oauth-callback?code=abc&state=x")!
        var receivedScheme: String?

        await sut.login { _, scheme in
            receivedScheme = scheme
            return callback
        }

        #expect(receivedScheme == "swdestinytrades")
        #expect(authService.receivedCallbackURL == callback)
        #expect(sut.isLoggedIn)
        #expect(sut.isLoading == false)
    }

    @Test
    func login_cancelledByUser_showsNoError() async {
        await sut.login { _, _ in throw ASWebAuthenticationSessionError(.canceledLogin) }

        #expect(sut.isLoggedIn == false)
        #expect(sut.toastQueue.current == nil)
    }

    @Test
    func login_failure_showsErrorToast() async {
        authService.completeLoginError = AuthError.tokenRequestFailed

        await sut.login { _, _ in URL(string: "swdestinytrades://oauth-callback")! }

        #expect(sut.isLoggedIn == false)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func login_notConfigured_showsErrorWithoutOpeningBrowser() async {
        authService.authorizationURLError = AuthError.notConfigured
        var didAuthenticate = false

        await sut.login { _, _ in
            didAuthenticate = true
            return URL(string: "swdestinytrades://oauth-callback")!
        }

        #expect(didAuthenticate == false)
        #expect(sut.errorMessage == AuthError.notConfigured.localizedDescription)
    }

    @Test
    func logout_clearsLoginState() {
        authService.isLoggedIn = true
        sut.refresh()

        sut.logout()

        #expect(sut.isLoggedIn == false)
        #expect(authService.logoutCallCount == 1)
    }
}
