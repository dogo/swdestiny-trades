//
//  DieFaceView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/05/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DieFaceView: UIView {

    var faceContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 15.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.red.cgColor
        view.backgroundColor = .lightGray
        return view
    }()

    var stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()

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
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureDie(face: face)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable:next cyclomatic_complexity
    internal func configureDie(face: String) {
        if face.contains("+") {
            symbol.tintColor = .blue
            quantity.textColor = .blue
        } else {
            symbol.tintColor = .black
            quantity.textColor = .black
        }

        var allowed = CharacterSet()
        allowed.formUnion(CharacterSet.decimalDigits)
        allowed.formUnion(CharacterSet.symbols)
        allowed.formUnion(CharacterSet(charactersIn: "X"))

        let face2 = face.trimmingCharacters(in: allowed)

        switch face2.uppercased() {
        case "MD":
            symbol.image = Asset.icMelee.image.withRenderingMode(.alwaysTemplate)
        case "RD":
            symbol.image = Asset.icRanged.image.withRenderingMode(.alwaysTemplate)
        case "R":
            symbol.image = Asset.icResource.image.withRenderingMode(.alwaysTemplate)
        case "DR":
            symbol.image = Asset.icDisrupt.image.withRenderingMode(.alwaysTemplate)
        case "-":
            symbol.image = Asset.icBlank.image.withRenderingMode(.alwaysTemplate)
            quantity.isHidden = true
        case "SP":
            symbol.image = Asset.icSpecial.image.withRenderingMode(.alwaysTemplate)
            quantity.isHidden = true
        case "F":
            symbol.image = Asset.icFocus.image.withRenderingMode(.alwaysTemplate)
        case "SH":
            symbol.image = Asset.icShield.image.withRenderingMode(.alwaysTemplate)
        case "DC":
            symbol.image = Asset.icDiscard.image.withRenderingMode(.alwaysTemplate)
        case "ID":
            symbol.image = Asset.icIndirect.image.withRenderingMode(.alwaysTemplate)
        default:
            symbol.isHidden = true
        }
        quantity.text = face.trimmingCharacters(in: allowed.inverted)
    }
}

extension DieFaceView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        stackView.addArrangedSubview(quantity)
        stackView.addArrangedSubview(symbol)
        faceContainer.addSubview(stackView)
        addSubview(faceContainer)
    }

    internal func setupConstraints() {
        faceContainer.layout.applyConstraint { make in
            make.topAnchor(equalTo: topAnchor)
            make.leadingAnchor(equalTo: leadingAnchor)
            make.bottomAnchor(equalTo: bottomAnchor)
            make.trailingAnchor(equalTo: trailingAnchor)
        }

        stackView.layout.applyConstraint { make in
            make.topAnchor(equalTo: faceContainer.topAnchor)
            make.leadingAnchor(equalTo: faceContainer.leadingAnchor, constant: 8)
            make.bottomAnchor(equalTo: faceContainer.bottomAnchor)
            make.trailingAnchor(equalTo: faceContainer.trailingAnchor, constant: -8)
        }

        symbol.layout.applyConstraint { make in
            make.heightAnchor(equalToConstant: 25)
            make.widthAnchor(equalToConstant: 25)
        }
    }

    internal func configureViews() {
        backgroundColor = .clear
    }
}
