//
//  ToastItem.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct ToastItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let type: ToastType
    let duration: TimeInterval
    let onDismiss: (() -> Void)?

    init(title: String, message: String, type: ToastType, duration: TimeInterval = 2.0, onDismiss: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.type = type
        self.duration = duration
        self.onDismiss = onDismiss
    }
}
