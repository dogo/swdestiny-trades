//
//  LoanView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailView: UIView, BaseViewConfiguration {

    let loanDetailTableView: LoanDetailTableView = {
        let view = LoanDetailTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(loanDetailTableView)
        loanDetailTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        loanDetailTableView
            .topAnchor(equalTo: self.topAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.bottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)

        activityIndicator
            .centerXAnchor(equalTo: self.centerXAnchor)
            .centerYAnchor(equalTo: self.centerYAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
