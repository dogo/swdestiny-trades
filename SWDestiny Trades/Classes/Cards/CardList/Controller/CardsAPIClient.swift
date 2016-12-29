//
//  CardsAPIClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class CardsAPIClient: BaseAPIClient {

    static let baseAPIClient = BaseAPIClient.sharedInstance

    static func retrieveSetCardList(setCode: String, successBlock: @escaping (_ setsDTO: Array<CardDTO>) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/cards/\(setCode)"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().mapArray(JSONObject: data)!)
            case .failure(_):
                failureBlock(response)
            }
        }
    }

    static func retrieveAllCards(successBlock: @escaping (_ setsDTO: Array<CardDTO>) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/cards/"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().mapArray(JSONObject: data)!)
            case .failure(_):
                failureBlock(response)
            }
        }
    }
    
    static func retrieveCard(successBlock: @escaping (_ cardDTO: CardDTO) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/card/01001"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().map(JSONObject: data)!)
            case .failure(_):
                failureBlock(response)
            }
        }
    }
}
