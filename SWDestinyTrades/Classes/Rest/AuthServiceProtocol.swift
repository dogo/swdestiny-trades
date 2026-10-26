//
//  AuthServiceProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AuthServiceProtocol: AnyObject {

    var isLoggedIn: Bool { get }

    func authorizationURL() throws -> URL

    func completeLogin(callbackURL: URL) async throws

    func logout()
}
