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
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
        Alamofire.request(url, method: .delete, parameters: ["": ""], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                completionHandler(response)
            }
    }
}
