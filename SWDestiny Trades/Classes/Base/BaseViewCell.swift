//
//  BaseCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class BaseViewCell: UIView, BaseViewConfiguration {

    let textContainer: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let accessoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    static func height() -> CGFloat {
        return 53
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func buildViewHierarchy() {
        self.addSubview(contentView)
        contentView.addSubview(textContainer)
        contentView.addSubview(iconImageView)
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(subtitleLabel)
        contentView.addSubview(accessoryLabel)
    }

    internal func setupConstraints() {
        contentView
            .inset(to: self, withInset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        textContainer
            .topAnchor(equalTo: self.contentView.topAnchor)
            .leadingAnchor(equalTo: self.iconImageView.trailingAnchor, constant: 12)
            .bottomAnchor(equalTo: self.contentView.bottomAnchor)
            .trailingAnchor(equalTo: self.accessoryLabel.leadingAnchor)

        iconImageView
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            .heightAnchor(equalTo: 25)
            .widthAnchor(equalTo: 25)

        accessoryLabel
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)
    }

    internal func configureViews() {
        contentView.backgroundColor = .white
    }
}
