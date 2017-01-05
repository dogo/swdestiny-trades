//
//  StringUtils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind: String, linkURL: String) {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
        }
    }
}
