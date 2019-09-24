//
//  CardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import ImageSlideshow

final class CardView: UIView, BaseViewConfiguration {

    let slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow(frame: .zero)
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.backgroundColor = .blackWhite
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.pageIndicator = nil
        slideshow.circular = false
        slideshow.preload = .fixed(offset: 1)
        return slideshow
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(slideshow)
    }

    internal func setupConstraints() {
        slideshow
            .topAnchor(equalTo: self.safeTopAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.safeBottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .blackWhite
    }
}
