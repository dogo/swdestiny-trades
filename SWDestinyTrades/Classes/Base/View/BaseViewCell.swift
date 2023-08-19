//
//  BaseViewCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class BaseViewCell: UIView {
    let contentView = UIView(frame: .zero)

    let textContainer: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let accessoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
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
}

extension BaseViewCell: BaseViewConfiguration {
    func buildViewHierarchy() {
        addSubview(contentView)
        contentView.addSubview(textContainer)
        contentView.addSubview(iconImageView)
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(subtitleLabel)
        contentView.addSubview(accessoryLabel)
    }

    func setupConstraints() {
        contentView.layout.applyConstraint { view in
            view.inset(to: self, withInset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        textContainer.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor)
            view.leadingAnchor(equalTo: self.iconImageView.trailingAnchor, constant: 12)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor)
            view.trailingAnchor(equalTo: self.accessoryLabel.leadingAnchor)
        }

        iconImageView.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            view.heightAnchor(equalToConstant: 25)
            view.widthAnchor(equalToConstant: 25)
        }

        accessoryLabel.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
        }
    }

    func configureViews() {}
}
