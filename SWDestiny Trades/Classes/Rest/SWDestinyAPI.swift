//
//  SWDestinyAPI.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

class SWDestinyAPI: SWDestinyService {

    let provider: MoyaProvider<SWDestinyRoute>

    init(provider: MoyaProvider<SWDestinyRoute> = MoyaProvider<SWDestinyRoute>()) {
        self.provider = provider
    }

    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) -> Cancellable {
        return provider.request(.setList()) { moyaResult in
            let result: Result<[SetDTO]>
            do {
                switch moyaResult {
                case .success(let response):
                    result = .success(try JSONDecoder().decode([SetDTO].self, from: response.data))
                case .failure(let error):
                    throw error
                }
            } catch {
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return provider.request(.cardList(setCode: setCode)) { moyaResult in
            let result: Result<[CardDTO]>
            do {
                switch moyaResult {
                case .success(let response):
                    result = .success(try JSONDecoder().decode([CardDTO].self, from: response.data))
                case .failure(let error):
                    throw error
                }
            } catch {
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return provider.request(.allCards()) { moyaResult in
            let result: Result<[CardDTO]>
            do {
                switch moyaResult {
                case .success(let response):
                    result = .success(try JSONDecoder().decode([CardDTO].self, from: response.data))
                case .failure(let error):
                    throw error
                }
            } catch {
                result = .failure(error)
            }
            completion(result)
        }
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) -> Cancellable {
        return provider.request(.card(cardId: cardId)) { moyaResult in
            let result: Result<CardDTO>
            do {
                switch moyaResult {
                case .success(let response):
                    result = .success(try JSONDecoder().decode(CardDTO.self, from: response.data))
                case .failure(let error):
                    throw error
                }
            } catch {
                result = .failure(error)
            }
            completion(result)
        }
    }
}
