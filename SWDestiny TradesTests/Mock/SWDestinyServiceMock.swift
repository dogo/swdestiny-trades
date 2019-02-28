//
//  SWDestinyServiceMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//
import Moya

@testable import SWDestiny_Trades

class RequestMock: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}

class SWDestinyServiceMock: SWDestinyService {

    let api: SWDestinyService

    init() {
        let endpointClosure = { (target: SWDestinyRoute) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString, sampleResponseClosure: {
                .networkResponse(200, target.sampleData)
            }, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }

        let provider = MoyaProvider<SWDestinyRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        api = SWDestinyAPI(provider: provider)
    }

    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) -> Cancellable {
        return api.retrieveSetList { moyaResult in
            let result: Result<[SetDTO]>
            switch moyaResult {
            case .success(let response):
                result = .success(response)
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return api.retrieveSetCardList(setCode: "") { moyaResult in
            let result: Result<[CardDTO]>
            switch moyaResult {
            case .success(let response):
                result = .success(response)
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return api.retrieveAllCards { moyaResult in
            let result: Result<[CardDTO]>
            switch moyaResult {
            case .success(let response):
                result = .success(response)
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) -> Cancellable {
        return api.retrieveCard(cardId: "") { moyaResult in
            let result: Result<CardDTO>
            switch moyaResult {
            case .success(let response):
                result = .success(response)
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
    }
}
