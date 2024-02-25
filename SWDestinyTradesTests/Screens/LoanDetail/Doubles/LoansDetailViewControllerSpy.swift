//
//  LoansDetailViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class LoansDetailViewControllerSpy: UIViewController, LoansDetailViewControllerProtocol {

    private(set) var didCallUpdateTableViewData = [PersonDTO]()
    func updateTableViewData(person: PersonDTO) {
        didCallUpdateTableViewData.append(person)
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
