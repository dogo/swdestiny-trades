//
//  SWDestinyAPI.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class SWDestinyAPI: BaseAPIClient {

    static let baseAPIClient = BaseAPIClient.sharedInstance

    static func retrieveSetList(successBlock: @escaping (_ setsDTO: [SetDTO]) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/sets/"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<SetDTO>().mapArray(JSONObject: data)!)
            case .failure:
                ToastMessages.showNetworkErrorMessage()
                failureBlock(response)
            }
        }
    }

    static func retrieveSetCardList(setCode: String, successBlock: @escaping (_ setsDTO: [CardDTO]) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/cards/\(setCode)"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().mapArray(JSONObject: data)!)
            case .failure:
                ToastMessages.showNetworkErrorMessage()
                failureBlock(response)
            }
        }
    }

    static func retrieveAllCards(successBlock: @escaping (_ setsDTO: [CardDTO]) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/cards/"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().mapArray(JSONObject: data)!)
            case .failure:
                ToastMessages.showNetworkErrorMessage()
                failureBlock(response)
            }
        }
    }

    static func retrieveCard(cardId: String, successBlock: @escaping (_ cardDTO: CardDTO) -> Void, failureBlock: @escaping (DataResponse<Any>) -> Void) {
        let path = "/api/public/card/\(cardId)"
        baseAPIClient.GET(url: BaseAPIClient.baseUrl + path, headers: ["": ""], parameters: ["": ""]) { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                successBlock(Mapper<CardDTO>().map(JSONObject: data)!)
            case .failure:
                ToastMessages.showNetworkErrorMessage()
                failureBlock(response)
            }
        }
    }
}
