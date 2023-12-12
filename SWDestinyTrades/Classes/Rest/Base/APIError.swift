//
//  APIError.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 16/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {
    case requestFailed(reason: String?)
    case jsonConversionFailure(domain: String, description: String)
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case requestCancelled
    case keyNotFound(key: CodingKey, context: String)
    case valueNotFound(type: Any.Type, context: String)
    case typeMismatch(type: Any.Type, context: String)
    case dataCorrupted(context: String)

    var localizedDescription: String {
        switch self {
        case let .requestFailed(reason):
            return "Request failed with reason: \(reason ?? "unknown")"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case let .jsonConversionFailure(domain, description):
            return "Error in read(from:ofType:) domain= \(domain), description= \(description)"
        case .requestCancelled:
            return "Request Cancelled"
        case let .keyNotFound(key, context):
            return "Could not find key \(key) in JSON: \(context)"
        case let .valueNotFound(type, context):
            return "Could not find type \(type) in JSON: \(context)"
        case let .typeMismatch(type, context):
            return "Type mismatch for type \(type) in JSON: \(context)"
        case let .dataCorrupted(context):
            return "Data found to be corrupted in JSON: \(context)"
        }
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case let (.requestFailed(lhsReason), .requestFailed(rhsReason)):
            return lhsReason == rhsReason
        case (.invalidData, .invalidData),
             (.responseUnsuccessful, .responseUnsuccessful),
             (.jsonParsingFailure, .jsonParsingFailure):
            return true
        case let (.jsonConversionFailure(lhsDomain, lhsDescription), .jsonConversionFailure(rhsDomain, rhsDescription)):
            return lhsDomain == rhsDomain && lhsDescription == rhsDescription
        case (.requestCancelled, .requestCancelled):
            return true
        case let (.keyNotFound(lhsKey, lhsContext), .keyNotFound(rhsKey, rhsContext)):
            return lhsKey.stringValue == rhsKey.stringValue && lhsContext == rhsContext
        case let (.valueNotFound(lhsType, lhsContext), .valueNotFound(rhsType, rhsContext)),
             let (.typeMismatch(lhsType, lhsContext), .typeMismatch(rhsType, rhsContext)):
            return lhsType == rhsType && lhsContext == rhsContext
        case let (.dataCorrupted(lhsContext), .dataCorrupted(rhsContext)):
            return lhsContext == rhsContext
        default:
            return false
        }
    }
}

final class RequestError {
    var reason: APIError
    var statusCode: HttpStatusCode

    init(_ statusCode: HttpStatusCode, reason: APIError) {
        self.statusCode = statusCode
        self.reason = reason
    }
}
