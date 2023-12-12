//
//  HttpClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

final class HttpClient: HttpClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension HttpClient {

    var logger: NetworkingLogger {
        return NetworkingLogger(level: .debug)
    }

    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {

        logger.log(request: request)

        let requestDate = Date()

        do {
            let (data, response) = try await session.data(for: request)

            let responseTime = Date().timeIntervalSince(requestDate)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidData
            }

            logger.log(response: response, data: data, time: responseTime)

            guard case 200 ... 300 = httpResponse.statusCode else {
                throw APIError.responseUnsuccessful
            }

            return try decodeData(data, decode: T.self)
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.requestCancelled
        } catch {
            throw error
        }
    }

    func cancelAllRequests() {
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    // MARK: - Helper

    private func decodeData<T: Decodable>(_ data: Data, decode: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            throw APIError.keyNotFound(key: key, context: context.debugDescription)
        } catch let DecodingError.valueNotFound(type, context) {
            throw APIError.valueNotFound(type: type, context: context.debugDescription)
        } catch let DecodingError.typeMismatch(type, context) {
            throw APIError.typeMismatch(type: type, context: context.debugDescription)
        } catch let DecodingError.dataCorrupted(context) {
            throw APIError.dataCorrupted(context: context.debugDescription)
        }
    }
}
