//
//  SWDestinyServiceImpl.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

class SWDestinyServiceImpl: SWDestinyService {

    let moyaProvider = MoyaProvider<SWDestinyAPI>()

    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) {
        moyaProvider.request(.setList()) { moyaResult in
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

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) {
        moyaProvider.request(.cardList(setCode: setCode)) { moyaResult in
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

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) {
        moyaProvider.request(.allCards()) { moyaResult in
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

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) {
        moyaProvider.request(.card(cardId: cardId)) { moyaResult in
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
