//
//  PopoverMenuManagerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class PopoverMenuManagerSpy: PopoverMenuManagerType {

    private(set) var didCallShowPopoverMenuCount = 0
    var executeDoneBlock = false
    var executeCancelBlock = false
    func showPopoverMenu(forEvent event: UIEvent,
                         with menuArray: [String],
                         done: ((NSInteger) -> Void)?,
                         cancel: (() -> Void)?) {
        didCallShowPopoverMenuCount += 1
        if executeDoneBlock {
            done?(0)
        }
        if executeCancelBlock {
            cancel?()
        }
    }
}
