//
//  BaseCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class BaseViewCell: UIView, BaseViewConfiguration {

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    var accessoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    var contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
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

    internal func buildViewHierarchy() {
        self.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(accessoryLabel)
    }

    internal func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(12)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(contentView).offset(12)
            make.bottom.equalTo(contentView)
        }

        accessoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-12)
        }
    }

    internal func configureViews() {
    }
}
