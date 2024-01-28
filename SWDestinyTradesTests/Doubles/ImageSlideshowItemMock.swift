//
//  ImageSlideshowItemMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import ImageSlideshow
@testable import SWDestinyTrades

final class ImageSlideshowItemMock: ImageSlideshowItem {

    override init(image: InputSource, zoomEnabled: Bool, activityIndicator: ActivityIndicatorView? = nil, maximumScale: CGFloat = 2.0) {
        super.init(image: image, zoomEnabled: zoomEnabled, activityIndicator: activityIndicator, maximumScale: maximumScale)
        imageView.image = Asset.ic404.image
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
