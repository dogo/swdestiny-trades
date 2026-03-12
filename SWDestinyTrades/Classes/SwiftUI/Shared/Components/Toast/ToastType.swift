//
//  ToastType.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 13/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

enum ToastType {
    case success
    case error
    case info

    var icon: String {
        switch self {
        case .success:
            return "checkmark"
        case .error:
            return "xmark"
        case .info:
            return "info"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success:
            return Color(red: 0.4, green: 0.65, blue: 0.2)
        case .error:
            return Color.red
        case .info:
            return Color.blue
        }
    }
}
