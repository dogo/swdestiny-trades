//
//  Bundle+Utils.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        guard let version = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        #if targetEnvironment(simulator)
            return "#DEADBEFF"
        #else
            return version
        #endif
    }

    var buildVersionNumber: String {
        guard let version = infoDictionary?["CFBundleVersion"] as? String else {
            return ""
        }
        #if targetEnvironment(simulator)
            return "42"
        #else
            return version
        #endif
    }

    var appBundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "com.swdestiny.trades"
    }
}
