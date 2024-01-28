//
//  DispatchQueueSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class DispatchQueueSpy: DispatchQueueType {

    private(set) var didCallAsyncExecute = 0
    func async(execute work: @escaping @convention(block) () -> Void) {
        didCallAsyncExecute += 1
        work()
    }

    private(set) var didCallGlobalAsyncExecute = 0
    func globalAsync(execute work: @escaping @convention(block) () -> Void) {
        didCallGlobalAsyncExecute += 1
        work()
    }
}
