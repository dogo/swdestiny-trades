//
//  UIColor+DarkMode.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 23/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIColor {
    static var whiteBlack: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }

    static var blackWhite: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? .black : .white
            }
        } else {
            return .white
        }
    }

    static var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? .systemGray : .darkGray
            }
        } else {
            return .darkGray
        }
    }

    static var sectionColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? .systemGray3 : .lightGray
            }
        } else {
            return .lightGray
        }
    }
}
