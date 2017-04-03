//
//  BackCardView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 03/04/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class BackCardView: UIView, BaseViewConfiguration {

    var cardName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()

    var cardOtherStats: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()

    var cardTypeAndStats: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()

    var cardText: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    var cardDieFaces: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 2.0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCardView(cardDTO: CardDTO) {
        cleanup()

        cardName.text = cardDTO.name
        if !cardDTO.subtitle.isEmpty {
            cardName.text?.append(" - \(cardDTO.subtitle)")
        }
        cardOtherStats.text = "\(cardDTO.affiliationName). \(cardDTO.factionName). \(cardDTO.rarityName)."

        cardTypeAndStats.text = "\(cardDTO.typeName). "
        if cardDTO.typeCode == "character" {
            cardTypeAndStats.text?.append("Points: \(cardDTO.points). Health: \(cardDTO.health).")
        } else if cardDTO.typeCode != "battlefield" {
            cardTypeAndStats.text?.append("Cost: \(cardDTO.cost).")
        }

        let formattedText = cardDTO.text.removeHTMLTag()
        let attributedString = NSMutableAttributedString(string: formattedText)

        let regex = try? NSRegularExpression(pattern: "\\[(.*?)\\]", options: .caseInsensitive)

        if let matches = regex?.matches(in: formattedText, options: [], range: NSRange(location: 0, length: formattedText.count)) {
            for result in matches.reversed() {
                let match = (formattedText as NSString).substring(with: result.range)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = specialIcon(attribute: DieAttribute(fromRawValue: match)).tintColor(.white)
                imageAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
                let replacementForTemplate = NSAttributedString(attachment: imageAttachment)
                attributedString.replaceCharacters(in: result.range, with: replacementForTemplate)
            }
            cardText.attributedText = attributedString
        }

        for dieFace in cardDTO.dieFaces {
            if let face = dieFace.value {
                cardDieFaces.addArrangedSubview(DieFaceView(face: face))
            }
        }
    }

    enum DieAttribute: String, CaseIterable {
        case ranged = "[ranged]"
        case resource = "[resource]"
        case melee = "[melee]"
        case indirect = "[indirect]"
        case special = "[special]"
        case blank = "[blank]"
        case disrupt = "[disrupt]"
        case focus = "[focus]"
        case discard = "[discard]"
        case shield = "[shield]"
        case leg = "[LEG]"
        case conv = "[CONV]"
        case atg = "[AtG]"
        case unknown

        init(fromRawValue: String) {
            self = DieAttribute(rawValue: fromRawValue) ?? .unknown
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func specialIcon(attribute: DieAttribute) -> UIImage {
        switch attribute {
        case .ranged:
            return Asset.icRanged.image
        case .resource:
            return Asset.icResource.image
        case .melee:
            return Asset.icMelee.image
        case .indirect:
            return Asset.icIndirect.image
        case .special:
            return Asset.icSpecial.image
        case .blank:
            return Asset.icBlank.image
        case .disrupt:
            return Asset.icDisrupt.image
        case .focus:
            return Asset.icFocus.image
        case .discard:
            return Asset.icDiscard.image
        case .shield:
            return Asset.icShield.image
        case .leg:
            return Asset.Sets.icLegacies.image
        case .conv:
            return Asset.Sets.icConvergence.image
        case .atg:
            return Asset.Sets.icAcrossTheGalaxy.image
        default:
            return Asset.NavigationBar.icAbout.image
        }
    }

    private func cleanup() {
        cardName.text = ""
        cardOtherStats.text = ""
        cardTypeAndStats.text = ""
        cardText.text = ""
        cardDieFaces.removeAllArrangedSubviews()
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        addSubview(cardName)
        addSubview(cardOtherStats)
        addSubview(cardTypeAndStats)
        addSubview(cardText)
        addSubview(cardDieFaces)
    }

    internal func setupConstraints() {
        cardName.layout.applyConstraint { make in
            make.topAnchor(equalTo: topAnchor, constant: 30)
            make.leadingAnchor(equalTo: leadingAnchor, constant: 10)
        }

        cardOtherStats.layout.applyConstraint { make in
            make.topAnchor(equalTo: cardName.bottomAnchor, constant: 5)
            make.leadingAnchor(equalTo: leadingAnchor, constant: 10)
        }

        cardTypeAndStats.layout.applyConstraint { make in
            make.topAnchor(equalTo: cardOtherStats.bottomAnchor, constant: 5)
            make.leadingAnchor(equalTo: leadingAnchor, constant: 10)
        }

        cardText.layout.applyConstraint { make in
            make.leadingAnchor(equalTo: leadingAnchor, constant: 10)
            make.trailingAnchor(equalTo: trailingAnchor, constant: -10)
            make.centerYAnchor(equalTo: centerYAnchor)
        }

        cardDieFaces.layout.applyConstraint { make in
            make.topAnchor(equalTo: cardText.bottomAnchor, constant: 15)
            make.leadingAnchor(equalTo: leadingAnchor, constant: 10)
            make.trailingAnchor(equalTo: trailingAnchor, constant: -10)
            make.heightAnchor(equalToConstant: 55)
        }
    }

    internal func configureViews() {
        backgroundColor = ColorPalette.appTheme
    }
}
