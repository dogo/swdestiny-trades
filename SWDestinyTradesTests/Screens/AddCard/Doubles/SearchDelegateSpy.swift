//
//  SearchDelegateSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SearchDelegateSpy: SearchDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    private(set) var didCallDidSelectRow = [IndexPath]()
    func didSelectRow(at index: IndexPath) {
        didCallDidSelectRow.append(index)
    }

    private(set) var didCallDidSelectAccessory = [IndexPath]()
    func didSelectAccessory(at index: IndexPath) {
        didCallDidSelectAccessory.append(index)
    }

    private(set) var didCallDidSelectSegment = [Int]()
    func didSelectSegment(index: Int) {
        didCallDidSelectSegment.append(index)
    }
}
