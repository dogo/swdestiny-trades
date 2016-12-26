//
//  SetsAPIClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class SetsAPIClient: BaseAPIClient {
    
    static let baseAPIClient = BaseAPIClient.sharedInstance
    
    static func retrieveSetList(successBlock: @escaping (_ setsDTO: Array<SetDTO>) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/sets/"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["" : ""], parameters: ["" : ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<SetDTO>().mapArray(JSONObject: data)!)
            case .failure(_):
                failureBlock(response)
            }
        }
    }
}

