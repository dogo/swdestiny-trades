//
//  NetworkingLogger.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 30/10/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
import OSLog

final class NetworkingLogger {
    enum LogLevel {
        case none
        case info
        case debug
    }

    private let loglevel: LogLevel
    private let outputStream: TextOutputStream

    init(level: LogLevel, outputStream: TextOutputStream = OSLogOutputStream()) {
        loglevel = level
        self.outputStream = outputStream
    }

    // MARK: - Log Request

    func log(request: URLRequest) {
        guard loglevel != .none else { return }

        if let method = request.httpMethod, let url = request.url {
            printSeparator()
            printTagged("🚀 \(method) \(url.absoluteString)")
            if loglevel == .debug {
                log(headers: request.allHTTPHeaderFields)
                log(body: request.httpBody)
            }
        }
    }

    // MARK: - Log Response

    func log(response: URLResponse?, data: Data?, time: TimeInterval) {
        guard loglevel != .none else { return }

        if let response = response as? HTTPURLResponse {
            let emoji = response.statusCode < 400 ? "✅" : "❌"
            printTagged("\(emoji) \(response.statusCode) • \(time.toCompactString())")
        }

        if loglevel == .debug {
            logJSON(data)
        }
        printSeparator()
    }

    // MARK: - Log Error

    func logError(request: URLRequest, statusCode: Int, error: Error?) {
        guard let method = request.httpMethod,
              let url = request.url,
              let error else { return }
        printSeparator()
        printTagged("💥 \(statusCode) \(method) \(url.absoluteString)")
        printTagged("   \(error.localizedDescription)")
        printSeparator()
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

            if let prettyString = String(data: prettyData, encoding: .utf8) {
                prettyJSON(prettyString)
            } else {
                printTagged("📄 Response: <\(prettyData.count) bytes>")
            }
        } catch {
            if let string = String(data: data, encoding: .utf8) {
                printTagged("📄 Response: \(string)")
            } else {
                printTagged("📄 Response: <\(data.count) bytes>")
            }
        }
    }

    // MARK: - Log Headers

    private func log(method: String, url: String) {
        printTagged("\(method) '\(url)':")
    }

    // MARK: - Log Headers

    private func log(headers: [String: String]?) {
        guard let headers, !headers.isEmpty else { return }
        printTagged("📋 Headers:")
        headers.forEach { printTagged("   \($0): \($1)") }
    }

    // MARK: - Log Body

    private func log(body: Data?) {
        guard let httpBody = body else { return }
        if let bodyStr = String(data: httpBody, encoding: .utf8) {
            printTagged("📦 Body: \(bodyStr)")
        } else {
            printTagged("📦 Body: <\(httpBody.count) bytes>")
        }
    }

    // MARK: - Log Tag

    private func printTagged(_ string: String) {
        outputStream.write("LOGGER | " + string + "\n")
    }

    private func printSeparator() {
        outputStream.write("LOGGER | ───────────────────────────────────────────────────\n")
    }

    private func prettyJSON(_ string: String) {
        let components = string.components(separatedBy: "\n").filter { !$0.isEmpty }
        printTagged("📄 Response:")
        components.forEach { printTagged("   \($0)") }
    }
}

protocol TextOutputStream {
    func write(_ string: String)
}

struct OSLogOutputStream: TextOutputStream {
    private let logger = Logger(
        subsystem: Bundle.main.appBundleIdentifier,
        category: "Networking"
    )

    func write(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .newlines)
        guard !trimmed.isEmpty else { return }
        if trimmed.contains("💥") {
            logger.error("\(trimmed, privacy: .public)")
        } else {
            logger.debug("\(trimmed, privacy: .public)")
        }
    }
}

struct StandardOutputStream: TextOutputStream {
    func write(_ string: String) {
        print(string, terminator: "")
    }
}

extension TimeInterval {
    /// Convert to full timestamp format
    func toString() -> String {
        let time = NSInteger(self)

        let milliseconds = Int(truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%00.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, milliseconds)
    }

    /// Convert to compact format (e.g., "18ms" or "1.23s")
    func toCompactString() -> String {
        if self < 1 {
            return String(format: "%.0fms", self * 1000)
        } else {
            return String(format: "%.2fs", self)
        }
    }
}
