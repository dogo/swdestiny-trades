//
//  APIError.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 16/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed(reason: String?)
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case requestCancelled

    var localizedDescription: String {

        switch self {
        case .requestFailed(let reason):
            return "Request failed with reason: \(reason ?? "unknown")"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .requestCancelled:
            return "Request Cancelled"
        }
    }
}
