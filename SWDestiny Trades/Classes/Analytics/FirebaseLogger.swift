//
//  FirebaseLogger.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 23/10/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Firebase
import FirebaseAnalytics

struct FirebaseLogger: LoggerProtocol {

    func setup() {
        FirebaseApp.configure()
    }

    func log(event: Events, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
}
