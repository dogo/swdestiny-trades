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
    private let outputStream: TextOutputStream

    init(level: LogLevel, outputStream: TextOutputStream = StandardOutputStream()) {
        loglevel = level
        self.outputStream = outputStream
    }

    // MARK: - Log Request

    func log(request: URLRequest) {
        guard loglevel != .none else { return }

        if let method = request.httpMethod, let url = request.url {
            printSeparator()
            log(method: method, url: url.absoluteString)
            log(headers: request.allHTTPHeaderFields)
            log(body: request.httpBody)
        }
    }

    // MARK: - Log Response

    func log(response: URLResponse?, data: Data?, time: TimeInterval) {
        guard loglevel != .none else { return }

        if let response = response as? HTTPURLResponse, let url = response.url {
            log(statusCode: response.statusCode, url: url.absoluteString, time: time)
        }

        if loglevel == .debug {
            logJSON(data)
        }
    }

    // MARK: - Log Error

    func logError(request: URLRequest, statusCode: Int, error: Error?) {
        guard let method = request.httpMethod,
              let url = request.url,
              let error else { return }
        printTagged("[Error] \(statusCode) \(method) '\(url)':")
        printTagged("Description: \(error.localizedDescription)")
    }

    // MARK: - Log Body

    private func log(statusCode: Int, url: String, time: TimeInterval) {
        printTagged("\(statusCode) '\(url)'")
        printTagged("Duration: '\(time.toString())'")
    }

    // MARK: - Log JSON

    private func logJSON(_ data: Data?) {
        guard let data else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

            let prettyString = String(decoding: prettyData, as: UTF8.self)
            prettyJSON(prettyString)
        } catch {
            let string = String(decoding: data, as: UTF8.self)
            printTagged(string)
        }
    }

    // MARK: - Log Headers

    private func log(method: String, url: String) {
        printTagged("\(method) '\(url)':")
    }

    // MARK: - Log Headers

    private func log(headers: [String: String]?) {
        printTagged("Headers: [")
        headers?.forEach { printTagged("  \($0): \($1)") }
        printTagged("]")
    }

    // MARK: - Log Body

    private func log(body: Data?) {
        if let httpBody = body {
            let bodyStr = String(decoding: httpBody, as: UTF8.self)
            printTagged("Body: \(bodyStr)")
        }
    }

    // MARK: - Log Tag

    private func printTagged(_ string: String) {
        outputStream.write("LOGGER | " + string + "\n")
    }

    private func printSeparator() {
        outputStream.write("LOGGER |---------------------------------------------------\n")
    }

    private func prettyJSON(_ string: String) {
        let components = string.components(separatedBy: "\n")
        printTagged("JSON:")
        components.forEach { printTagged($0) }
    }
}

protocol TextOutputStream {
    func write(_ string: String)
}

struct StandardOutputStream: TextOutputStream {
    func write(_ string: String) {
        print(string)
    }
}

extension TimeInterval {
    func toString() -> String {
        let time = NSInteger(self)

        let milliseconds = Int(truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%00.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, milliseconds)
    }
}
