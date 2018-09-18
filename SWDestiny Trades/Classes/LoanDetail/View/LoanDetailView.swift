//
//  LoanView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailView: UIView, BaseViewConfiguration {

    let loanDetailTableView = LoanDetailTableView()
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(loanDetailTableView)
        loanDetailTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        loanDetailTableView.snp.makeConstraints { make in
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
        self.backgroundColor = .white
    }
}
