//
//  DiagnosticsLoggerProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DiagnosticsLoggerProtocol {
    func logError(_ message: String)
    func logInfo(_ message: String)
    func logDebug(_ message: String)
}
