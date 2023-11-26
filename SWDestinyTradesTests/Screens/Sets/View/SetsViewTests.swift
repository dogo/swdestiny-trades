//
//  SetsViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class SetsViewTests: QuickSpec {

    override class func spec() {

        var sut: SetsView!

        describe("SetsListView layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized") {

                beforeEach {}

                afterEach {}

                it("should have valid layout") {}
            }
        }
    }
}
