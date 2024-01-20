//
//  UICollectionView+IdentifiableTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 10/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class UICollectionViewIdentifiableTests: XCTestCase {

    private var sut: UICollectionView!

    override func setUp() {
        super.setUp()
        let layout = UICollectionViewFlowLayout()
        sut = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRegisterCell() {
        sut.register(cellType: TestCell.self)
        let cell = sut.dequeueReusableCell(for: IndexPath(item: 0, section: 0), cellType: TestCell.self)
        XCTAssertNotNil(cell)
    }

    func testDequeueReusableCellWithCorrectType() {
        sut.register(cellType: TestCell.self)
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.dequeueReusableCell(for: indexPath, cellType: TestCell.self)
        XCTAssertEqual(cell.reuseIdentifier, TestCell.reuseIdentifier)
    }
}

final class TestCell: UICollectionViewCell, Identifiable {}
