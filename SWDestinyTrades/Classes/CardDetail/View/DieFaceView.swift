//
//  DieFaceView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/05/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
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

    internal func configureDie(face: String) {
        if face.contains("+") {
            symbol.tintColor = .blue
            quantity.textColor = .blue
        } else {
            symbol.tintColor = .black
            quantity.textColor = .black
        }

        let options = getSubtitle(input: face)
        if let firstOption = options.first {
            quantity.text = firstOption.quantity
            symbol.image = firstOption.icon
        }
    }

    func getSubtitle(input: String) -> [Option] {
        var options: [Option] = []

        let pattern = "(\\+?\\d+)?([A-Za-z\\-]+)?(\\d+)?"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))

        for match in matches {
            let quantityRange = Range(match.range(at: 1), in: input)
            let faceRange = Range(match.range(at: 2), in: input)
            let extraRange = Range(match.range(at: 3), in: input)

            let quantity = quantityRange.map { String(input[$0]) }
            let face = faceRange.map { String(input[$0]) }
            let extra = extraRange != nil ? assignImage(option: "R") : nil
            let icon = face.compactMap { assignImage(option: $0) }.first

            options.append(Option(quantity: quantity, face: face, icon: icon, extra: extra))
        }

        return options
    }

    func assignImage(option: String) -> UIImage? {
        print("[Debug] face:" + option)

        let imageMapping: [String: UIImage] = [
            "MD": Asset.icMelee.image,
            "RD": Asset.icRanged.image,
            "R": Asset.icResource.image,
            "DR": Asset.icDisrupt.image,
            "-": Asset.icBlank.image,
            "SP": Asset.icSpecial.image,
            "F": Asset.icFocus.image,
            "SH": Asset.icShield.image,
            "DC": Asset.icDiscard.image,
            "ID": Asset.icIndirect.image
        ]

        if let image = imageMapping[option.uppercased()] {
            quantity.isHidden = (option == "-" || option.uppercased() == "SP")
            symbol.isHidden = false
            return image.withRenderingMode(.alwaysTemplate)
        } else {
            symbol.isHidden = true
            return nil
        }
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

struct Option {
    let quantity: String?
    let face: String?
    let icon: UIImage?
    let extra: UIImage?
}
