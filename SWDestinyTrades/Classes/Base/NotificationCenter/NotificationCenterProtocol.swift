//
//  NotificationCenterProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 25/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol NotificationCenterProtocol {

    func post(_ notification: Notification)

    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?)

    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterProtocol {}
