//
//  NotificationCenterMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class NotificationCenterMock: NotificationCenterProtocol {

    private(set) var notificationNames: [Notification.Name] = []

    private(set) var didCallPostNotificationCount = 0
    func post(_ notification: Notification) {
        didCallPostNotificationCount += 1
        notificationNames.append(notification.name)
        NotificationCenter.default.post(notification)
    }

    private(set) var didCallAddObserverCount = 0
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?) {
        didCallAddObserverCount += 1

        if let aName {
            notificationNames.append(aName)
        }

        NotificationCenter.default.addObserver(observer,
                                               selector: aSelector,
                                               name: aName,
                                               object: anObject)
    }

    private(set) var didCallRemoveObserverCount = 0
    func removeObserver(_ observer: Any) {
        didCallRemoveObserverCount += 1
        NotificationCenter.default.removeObserver(observer)
    }
}
