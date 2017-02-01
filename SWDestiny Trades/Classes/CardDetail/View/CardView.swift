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

    var cardImageView: ImageSlideshow = {
        let slideshow = ImageSlideshow(frame: .zero)
        slideshow.backgroundColor = UIColor.red
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.isHidden = true
        slideshow.circular = false
        return slideshow
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(cardImageView)
    }

    internal func setupConstraints() {
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(64)
            make.left.equalTo(self)
            make.bottom.equalTo(self).offset(-49)
            make.right.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor =  .white
    }
}
