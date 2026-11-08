//
//  AnalyticsManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 23/10/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

final class AnalyticsManager: AnalyticsProtocol {
    static let shared: AnalyticsManager = {
        var manager = AnalyticsManager()
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            manager.loggers.append(FirebaseLogger())
        }
        manager.setup()
        return manager
    }()

    private var loggers: [AnalyticsProtocol] = []

    private init() {}

    func setup() {
        loggers.forEach { $0.setup() }
    }

    func log(event: Events, parameters: [String: Any]? = nil) {
        loggers.forEach { $0.log(event: event, parameters: parameters) }
    }
}
