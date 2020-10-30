//
//  NetworkingLogger.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 30/10/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

final class NetworkingLogger {

    enum LogLevel {
        case none
        case info
        case debug
    }

    private let loglevel: LogLevel

    required init(level: LogLevel) {
        self.loglevel = level
    }

    // MARK: - Log Request

    func log(request: URLRequest) {

        guard loglevel != .none else { return }

        if let method = request.httpMethod, let url = request.url {
            log(method: method, url: url.absoluteString)
            log(headers: request.allHTTPHeaderFields)
            log(body: request.httpBody)
        }
    }

    // MARK: - Log Response

    func log(response: URLResponse?, data: Data?) {

        guard loglevel != .none else { return }

        if let response = response as? HTTPURLResponse, let url = response.url {
            log(statusCode: response.statusCode, url: url.absoluteString)
        }

        if loglevel == .debug {
            logJSON(data)
        }
    }

    // MARK: - Log Body

    private func log(statusCode: Int, url: String) {
        debugPrint("\(statusCode) '\(url)'")
    }

    // MARK: - Log JSON

    private func logJSON(_ data: Data?) {
        if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            debugPrint(json)
        }
    }

    // MARK: - Log Headers

    private func log(method: String, url: String) {
        debugPrint("\(method) '\(url)'")
    }

    // MARK: - Log Headers

    private func log(headers: [String: String]?) {
        if let allHTTPHeaderfields = headers {
            for (key, value) in allHTTPHeaderfields {
                debugPrint("    \(key) : \(value)'")
            }
        }
    }

    // MARK: - Log Body

    private func log(body: Data?) {
        if let httpBody = body {
            let bodyStr = String(data: httpBody, encoding: .utf8) ?? String()
            debugPrint("    HttpBody : \(bodyStr)")
        }
    }
}
