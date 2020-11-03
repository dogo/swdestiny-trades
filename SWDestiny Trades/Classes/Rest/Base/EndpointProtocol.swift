//
//  EndpointProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

typealias HttpHeaders = [String: String]
typealias HttpParameters = [String: String]

protocol EndpointProtocol {
    var scheme: HttpScheme { get }
    var host: String { get }
    var path: String { get }
    var parameters: HttpParameters { get }
    var method: HttpMethod { get }
    var headers: HttpHeaders? { get }
}
