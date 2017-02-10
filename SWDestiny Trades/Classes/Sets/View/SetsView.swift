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

    var pullToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.black
        return refresh
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

    func endRefreshControl() {
        self.pullToRefresh.endRefreshing()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = "Last update: \(formatter.string(from: Date()))"
        let attrsDictionary = [NSForegroundColorAttributeName: UIColor.black]
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
        self.pullToRefresh.attributedTitle = attributedTitle
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(setsTableView)
        setsTableView.addSubview(activityIndicator)
        if #available(iOS 10.0, *) {
            setsTableView.refreshControl = pullToRefresh
        } else {
            setsTableView.addSubview(pullToRefresh)
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
    }
}
