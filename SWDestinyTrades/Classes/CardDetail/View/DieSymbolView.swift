//
//  DieSymbolView.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 08/09/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class DieSymbolView: UIStackView {

    var quantity: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    var symbol: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(face: String) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureDie(face: face)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureDie(face: String) {}
}

extension DieSymbolView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        addArrangedSubview(quantity)
        addArrangedSubview(symbol)
    }

    internal func setupConstraints() {
//        faceContainer.layout.applyConstraint { make in
//            make.topAnchor(equalTo: topAnchor)
//            make.leadingAnchor(equalTo: leadingAnchor)
//            make.bottomAnchor(equalTo: bottomAnchor)
//            make.trailingAnchor(equalTo: trailingAnchor)
//        }
//
//        stackView.layout.applyConstraint { make in
//            make.topAnchor(equalTo: faceContainer.topAnchor)
//            make.leadingAnchor(equalTo: faceContainer.leadingAnchor, constant: 8)
//            make.bottomAnchor(equalTo: faceContainer.bottomAnchor)
//            make.trailingAnchor(equalTo: faceContainer.trailingAnchor, constant: -8)
//        }

        symbol.layout.applyConstraint { make in
            make.heightAnchor(equalToConstant: 25)
            make.widthAnchor(equalToConstant: 25)
        }
    }

    internal func configureViews() {
        backgroundColor = .clear
    }
}
