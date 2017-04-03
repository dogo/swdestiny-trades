//
//  CardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import UIKit

final class CardView: UIView {
    let slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow(frame: .zero)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.backgroundColor = .blackWhite
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.pageIndicator = nil
        slideshow.circular = false
        slideshow.preload = .fixed(offset: 1)
        return slideshow
    }()

    lazy var backView = BackCardView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: slideshow.bounds.width,
                                                   height: slideshow.bounds.height))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardView: BaseViewConfiguration {
    internal func buildViewHierarchy() {
        addSubview(slideshow)
    }

    internal func setupConstraints() {
        slideshow.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.bottomAnchor(equalTo: self.safeBottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
        }
    }

    internal func configureViews() {
        backgroundColor = .blackWhite
    }
}
