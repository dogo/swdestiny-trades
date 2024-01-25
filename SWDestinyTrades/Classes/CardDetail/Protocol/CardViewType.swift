//
//  CardViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 25/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

protocol CardViewType where Self: UIView {

    var currentPageChanged: ((_ page: Int) -> Void)? { get set }

    func setSlideshowImageInputs(_ imageInputs: [InputSource])
    func setCurrentPage(_ page: Int, animated: Bool)
    func getCurrentPage() -> Int
    func getCurrentSlideshowItem() -> ImageSlideshowItem?
}
