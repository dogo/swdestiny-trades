//
//  AboutView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AboutView: UIView, UITextViewDelegate {

    var didTouchHTTPLink: ((URL) -> Void)?

    var logoImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.tintColor = .whiteBlack
        return image
    }()

    var versionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    var aboutTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        didTouchHTTPLink?(url)
        return false
    }
}

extension AboutView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.addSubview(logoImage)
        self.addSubview(versionLabel)
        self.addSubview(aboutTextView)
    }

    internal func setupConstraints() {
        logoImage.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor, constant: 34)
            view.centerXAnchor(equalTo: self.centerXAnchor)
            view.widthAnchor(equalTo: 280)
            view.heightAnchor(equalTo: 150)
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

    internal func configureViews() {

        self.backgroundColor = .blackWhite

        logoImage.image = Asset.Logo.largeIconBlack.image.withRenderingMode(.alwaysTemplate)

        aboutTextView.delegate = self
        aboutTextView.isEditable = false

        versionLabel.text = L10n.version(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber)

        let attributedString = NSMutableAttributedString(string: L10n.aboutText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.whiteBlack, range: NSRange(location: 0, length: attributedString.length))
        attributedString.setAsLink(textToFind: "https://swdestinydb.com", linkURL: "https://swdestinydb.com")

        aboutTextView.attributedText = attributedString
    }
}
