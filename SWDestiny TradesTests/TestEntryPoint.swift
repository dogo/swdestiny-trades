//
//  TestEntryPoint.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Nimble_Snapshots
import XCTest

final class TestEntryPoint: NSObject {
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(CurrentTestCaseTracker.shared)
    }
}
