//
//  AboutView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AboutView: UIView, AboutViewType {

    var didTouchHTTPLink: ((URL) -> Void)?

    private var logoImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.tintColor = .whiteBlack
        return image
    }()

    private var versionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    private lazy var aboutTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.delegate = self
        textView.isEditable = false
        textView.accessibilityIdentifier = "ABOUT_TEXT_VIEW"
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
        accessibilityIdentifier = "ABOUT_VIEW"
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutView: UITextViewDelegate {

    // MARK: - <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        didTouchHTTPLink?(url)
        return false
    }
}

extension AboutView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(logoImage)
        addSubview(versionLabel)
        addSubview(aboutTextView)
    }

    func setupConstraints() {
        logoImage.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor, constant: 34)
            view.centerXAnchor(equalTo: self.centerXAnchor)
            view.widthAnchor(equalToConstant: 280)
            view.heightAnchor(equalToConstant: 150)
        }

        versionLabel.layout.applyConstraint { view in
            view.topAnchor(equalTo: logoImage.bottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -15)
        }

        aboutTextView.layout.applyConstraint { view in
            view.topAnchor(equalTo: logoImage.bottomAnchor, constant: 22)
            view.leadingAnchor(equalTo: self.leadingAnchor, constant: 12)
            view.bottomAnchor(equalTo: self.safeBottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -12)
        }
    }

    func configureViews() {
        backgroundColor = .blackWhite

        logoImage.image = Asset.Logo.largeIconBlack.image.withRenderingMode(.alwaysTemplate)
        versionLabel.text = L10n.version(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber)

        let attributedString = NSMutableAttributedString(string: L10n.aboutText(L10n.swdestinydbWebsite))
        attributedString.addAttribute(.foregroundColor, value: UIColor.whiteBlack, range: NSRange(location: 0, length: attributedString.length))
        attributedString.setAsLink(textToFind: L10n.swdestinydbWebsite, linkURL: L10n.swdestinydbWebsite)

        aboutTextView.attributedText = attributedString
    }
}
