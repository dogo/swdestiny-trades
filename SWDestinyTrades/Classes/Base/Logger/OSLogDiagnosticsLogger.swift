//
//  OSLogDiagnosticsLogger.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import OSLog

final class OSLogDiagnosticsLogger: DiagnosticsLoggerProtocol {
    static let shared = OSLogDiagnosticsLogger()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.swdestiny.trades",
        category: "App"
    )

    private init() {}

    func logError(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }

    func logInfo(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    func logDebug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }
}
