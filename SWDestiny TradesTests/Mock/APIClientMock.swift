//
//  APIClientMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestiny_Trades

final class APIClientMock: APIClient {

    var session: URLSession = {
        URLSessionMock()
    }()
}
