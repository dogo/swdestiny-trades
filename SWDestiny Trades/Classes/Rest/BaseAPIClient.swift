//
//  BaseAPIClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPIClient {

    static let sharedInstance = BaseAPIClient()
    static let baseUrl = "http://swdestinydb.com"
    private init() {}

    // MARK: - RESTFull Request

    func GET(url: String, headers: [String: String], parameters: [String: String], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }

    func POST(url: String, headers: [String: String], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .post, parameters: ["": ""], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }

    func PATCH(url: String, headers: [String: String], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .patch, parameters: ["": ""], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }

    func PUT(url: String, headers: [String: String], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .put, parameters: ["": ""], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }

    func DELETE(url: String, headers: [String: String], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .delete, parameters: ["": ""], encoding: URLEncoding.queryString, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }
}

extension DataResponse {

    func failureReason() -> String {

        var errorDescription: String = ""

        if let error = self.result.error as? AFError {
            switch error {
            case .invalidURL(let url):
                errorDescription.append("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                errorDescription.append("Parameter encoding failed: \(error.localizedDescription)")
                errorDescription.append("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                errorDescription.append("Multipart encoding failed: \(error.localizedDescription)")
                errorDescription.append("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                errorDescription.append("Response validation failed: \(error.localizedDescription)")
                errorDescription.append("Failure Reason: \(reason)")

                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorDescription.append("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    errorDescription.append("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorDescription.append("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    errorDescription.append("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                errorDescription.append("Response serialization failed: \(error.localizedDescription)")
                errorDescription.append("Failure Reason: \(reason)")
            }
            errorDescription.append("Underlying error: \(error.underlyingError)")
        } else if let error = self.result.error as? URLError {
            errorDescription.append("URLError occurred: \(error)")
        } else {
            errorDescription.append("Unknown error: \(self.result.error)")
        }
        return errorDescription
    }
}
