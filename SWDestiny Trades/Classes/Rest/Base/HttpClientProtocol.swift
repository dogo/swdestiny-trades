//
//  HttpClientProtocol.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

protocol HttpClientProtocol {

    func request<T: Decodable>(_ request: URLRequest, decode: ((T) -> T)?, completion: @escaping (Result<T, APIError>) -> Void)

    func cancelAllRequests()
}

extension HttpClientProtocol {

    func request<T: Decodable>(_ request: URLRequest, decode: ((T) -> T)? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        self.request(request, decode: decode, completion: completion)
    }
}
