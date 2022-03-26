//
//  AboutViewType.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol AboutViewType where Self: UIView {

    var didTouchHTTPLink: ((URL) -> Void)? { get set }
}
