//
//  Identifiable.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Identifiable protocol

public protocol Identifiable: AnyObject {
    /// The reuse identifier to use when registering and later dequeuing a Identifiable cell
    static var reuseIdentifier: String { get }
}

// MARK: - Default implementation

public extension Identifiable {
    /// By default, use the name of the class as String for its reuseIdentifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
