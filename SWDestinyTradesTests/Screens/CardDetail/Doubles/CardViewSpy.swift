//
//  CardViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

@testable import SWDestinyTrades

final class CardViewSpy: UIView, CardViewType, CardDetailViewProtocol {

    var currentPageChanged: ((Int) -> Void)?

    private(set) var didCallSetSlideshowImageInputs = [InputSource]()
    func setSlideshowImageInputs(_ imageInputs: [InputSource]) {
        didCallSetSlideshowImageInputs.append(contentsOf: imageInputs)
    }

    private(set) var didCallSetCurrentPage = [(page: Int, animated: Bool)]()
    func setCurrentPage(_ page: Int, animated: Bool) {
        didCallSetCurrentPage.append((page, animated))
    }

    private(set) var didCallGetCurrentPageCount = 0
    func getCurrentPage() -> Int {
        didCallGetCurrentPageCount += 1
        return 0
    }

    private(set) var didCallGetCurrentSlideshowItemCount = 0
    func getCurrentSlideshowItem() -> ImageSlideshowItem? {
        didCallGetCurrentSlideshowItemCount += 1
        return nil
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }

    private(set) var didCallShowSuccessMessage = [CardDTO]()
    func showSuccessMessage(card: CardDTO) {
        didCallShowSuccessMessage.append(card)
    }
}
