//
//  PeopleListDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension PeopleListDatasource {

    var persons: [PersonDTO] {
        Mirror.extract(variable: "persons", from: self)!
    }
}
