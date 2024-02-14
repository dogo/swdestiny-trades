//
//  BalloonMarkerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Charts
import DGCharts
import XCTest

@testable import SWDestinyTrades

final class BalloonMarkerTests: XCTestCase {

    private var sut: BalloonMarker!

    override func setUp() {
        super.setUp()

        let color = UIColor.red
        let font = UIFont.systemFont(ofSize: 12)
        let textColor = UIColor.white
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        sut = BalloonMarker(color: color, font: font, textColor: textColor, insets: insets)
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_initialization() {
        XCTAssertEqual(sut.color, UIColor.red)
        XCTAssertEqual(sut.font, UIFont.systemFont(ofSize: 12))
        XCTAssertEqual(sut.textColor, UIColor.white)
        XCTAssertEqual(sut.insets, UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }

    func test_offsetForDrawing() {
        let point = CGPoint(x: 50, y: 50)
        let offset = sut.offsetForDrawing(atPoint: point)

        XCTAssertEqual(offset.x, 0.0)
        XCTAssertEqual(offset.y, 0.0)
    }

    func test_offsetForDrawing_with_zero_size_and_image() {
        let point = CGPoint(x: 50, y: 50)
        sut.image = Asset.ic404.image

        let offset = sut.offsetForDrawing(atPoint: point)

        XCTAssertEqual(offset.x, 108.0)
        XCTAssertEqual(offset.y, 371.0)
    }

    func test_offsetForDrawing_exceeding_chart_width() {
        let chartWidth = 100
        let point = CGPoint(x: chartWidth - 30, y: 50)

        sut.size = CGSize(width: 40, height: 30)

        let chartView = ChartViewBase()
        sut.chartView = chartView

        let offset = sut.offsetForDrawing(atPoint: point)

        // Verify that the offset is adjusted to fit within the chart view width
        XCTAssertEqual(offset.x, -98.0)
    }

    func test_refreshContent() {
        let entry = ChartDataEntry(x: 0, y: 10)
        let highlight = Highlight(x: 0, dataSetIndex: 0, stackIndex: 0)
        sut.refreshContent(entry: entry, highlight: highlight)

        XCTAssertEqual(sut.labelns, "10.0")
    }
}
