//
//  SetsPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SetsPresenterSpy: SetsPresenterProtocol {

    private(set) var didCallViewDidLoadCount = 0
    func viewDidLoad() {
        didCallViewDidLoadCount += 1
    }

    private(set) var didCallRetrieveSetsCount = 0
    func retrieveSets() {
        didCallRetrieveSetsCount += 1
    }

    private(set) var didCallAboutButtonTouchedCount = 0
    func aboutButtonTouched() {
        didCallAboutButtonTouchedCount += 1
    }

    private(set) var didCallSearchButtonTouchedCount = 0
    func searchButtonTouched() {
        didCallSearchButtonTouchedCount += 1
    }

    private(set) var didCallDidSelectSet = [SetDTO]()
    func didSelectSet(_ set: SetDTO) {
        didCallDidSelectSet.append(set)
    }
}
