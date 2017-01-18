//
//  DeckBuilderView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderView: UIView, BaseViewConfiguration {
    
    let deckBuilderTableView = DeckBuilderTableView()
    
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
        self.addSubview(deckBuilderTableView)
    }
    
    internal func setupConstraints() {
        deckBuilderTableView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }
    }
    
    internal func configureViews() {
        self.backgroundColor = UIColor.white
    }
}
