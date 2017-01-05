//
//  CardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardView: UIView, BaseViewConfiguration {

    var cardImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        return image
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
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor =  UIColor.white
    }
}
