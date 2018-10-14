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

    var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow(frame: .zero)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.backgroundColor = .white
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(slideshow)
    }

    internal func setupConstraints() {
        slideshow.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.snp.topMargin)
            make.left.equalTo(self)
            make.bottom.equalTo(self.safeArea.snp.bottomMargin)
            make.right.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
