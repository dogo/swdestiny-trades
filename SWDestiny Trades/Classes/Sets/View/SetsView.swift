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

    let activityIndicator = UIActivityIndicatorView(style: .gray)

    let pullToRefresh = UIRefreshControl()

    var textColor: UIColor = .black

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginRefreshing() {
        pullToRefresh.beginRefreshing()
    }

    func endRefreshControl() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = "Last update: \(formatter.string(from: Date()))"
        let attrsDictionary = [NSAttributedString.Key.foregroundColor: textColor]
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
        self.pullToRefresh.attributedTitle = attributedTitle
        self.pullToRefresh.endRefreshing()
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(setsTableView)
        setsTableView.addSubview(activityIndicator)
        if #available(iOS 10.0, *) {
            setsTableView.refreshControl = pullToRefresh
        } else {
            setsTableView.addSubview(pullToRefresh)
            setsTableView.sendSubviewToBack(pullToRefresh)
        }
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
        self.backgroundColor = .white
        if #available(iOS 11, *) {
            textColor = .white
        }
        self.pullToRefresh.tintColor = textColor
    }
}
