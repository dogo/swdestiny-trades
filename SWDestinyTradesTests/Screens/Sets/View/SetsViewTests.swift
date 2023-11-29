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

        describe("SetsListView") {

            beforeEach {
                sut = SetsView(frame: .testDevice)
            }

            context("when it's initialized") {

                it("should have valid layout") {
                    sut.updateSetList(SetDTO.stub())

                    expect(sut) == snapshot()
                }
            }

            context("didSelectSet") {

                it("should select a set") {

                    var didCallDidSelectSet = [SetDTO]()
                    sut.didSelectSet = { set in
                        didCallDidSelectSet.append(set)
                    }

                    sut.setsTableView?.didSelectSet?(.stub().first!)

                    expect(didCallDidSelectSet.count) == 1
                    expect(didCallDidSelectSet[0].name) == SetDTO.stub()[0].name
                }
            }
        }
    }
}
