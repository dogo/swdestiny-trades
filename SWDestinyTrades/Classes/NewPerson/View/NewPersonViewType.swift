//
//  NewPersonViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 29/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol NewPersonViewType where Self: UIView {

    func retriveUserInput() -> (name: String, lastName: String)
}
