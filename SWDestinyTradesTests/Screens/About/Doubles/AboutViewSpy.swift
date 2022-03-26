//
//  AboutViewSpy.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 22/09/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AboutViewSpy: UIView, AboutViewType {

    var didTouchHTTPLink: ((URL) -> Void)?
}

extension AboutViewSpy: UITextViewDelegate {

    // MARK: - <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        didTouchHTTPLink?(url)
        return false
    }
}
