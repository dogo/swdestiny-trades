//
//  XYMarkerViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import DGCharts
import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class XYMarkerViewTests: XCTestCase {

    private var sut: XYMarkerView!

    override func setUp() {
        super.setUp()
        sut = XYMarkerView(color: .lightGray,
                           font: UIFont.systemFont(ofSize: CGFloat(10.0)),
                           textColor: .white,
                           insets: .zero)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_refreshContent() {
        sut.refreshContent(entry: ChartDataEntry(x: 0, y: 0), highlight: Highlight())

        XCTAssertEqual(sut.labelns, "0 cards")
    }
}
