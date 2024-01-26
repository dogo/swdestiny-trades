//
//  CardViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardViewTests: XCSnapshotableTestCase {

    private var sut: CardView!

    override func setUp() {
        super.setUp()
        sut = CardView(frame: .testDevice)
        sut.setSlideshowImageInputs([
            ImageSource(image: Asset.ic404.image)
        ])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initialization() {
        XCTAssertTrue(snapshot(sut))
    }

    func test_currentPageChanged() {
        var didCallCurrentPageChanged = [Int]()
        sut.currentPageChanged = { index in
            didCallCurrentPageChanged.append(index)
        }

        sut.slideshow.currentPageChanged?(2)

        XCTAssertEqual(didCallCurrentPageChanged.count, 1)
        XCTAssertEqual(didCallCurrentPageChanged[0], 2)
    }

    func test_setSlideshowImageInputs() {
        sut.setSlideshowImageInputs([])

        XCTAssertEqual(sut.slideshow.images.count, 0)
    }

    func test_setCurrentPage() {
        sut.setCurrentPage(2, animated: false)

        XCTAssertEqual(sut.slideshow.currentPage, 2)
    }

    func test_getCurrentPage() {
        XCTAssertEqual(sut.getCurrentPage(), 0)
    }

    func test_getCurrentSlideshowItem() {
        XCTAssertNotNil(sut.getCurrentSlideshowItem())
    }
}
