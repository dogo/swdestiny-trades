//
//  SetsView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsView: UIView, BaseViewConfiguration {
    
    let setsTableView = SetsTableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
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
        self.addSubview(setsTableView)
        setsTableView.addSubview(activityIndicator)
    }
    
    internal func setupConstraints() {
        setsTableView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    internal func configureViews() {
        self.backgroundColor = UIColor.white
    }
}
