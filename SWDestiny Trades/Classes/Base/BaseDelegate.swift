//
//  BaseDelegate.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 13/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

protocol BaseDelegate: AnyObject {
    func didSelectRowAt(index: IndexPath)
}
