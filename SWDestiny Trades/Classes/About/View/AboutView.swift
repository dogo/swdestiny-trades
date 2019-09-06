//
//  AboutView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AboutView: UIView, BaseViewConfiguration, UITextViewDelegate {

    var didTouchHTTPLink: ((URL) -> Void)?

    var logoImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()

    var versionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    var aboutTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
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

    // MARK: - <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(logoImage)
        self.addSubview(versionLabel)
        self.addSubview(aboutTextView)
    }

    internal func setupConstraints() {
        logoImage
            .topAnchor(equalTo: self.safeTopAnchor, constant: 34)
            .centerXAnchor(equalTo: self.centerXAnchor)
            .widthAnchor(equalTo: 280)
            .heightAnchor(equalTo: 150)

        versionLabel
            .topAnchor(equalTo: logoImage.bottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor, constant: -15)

        aboutTextView
            .topAnchor(equalTo: logoImage.bottomAnchor, constant: 22)
            .leadingAnchor(equalTo: self.leadingAnchor, constant: 12)
            .bottomAnchor(equalTo: self.safeBottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor, constant: -12)
    }

    internal func configureViews() {

        self.backgroundColor = .white

        logoImage.image = Asset.Logo.largeIconBlack.image

        aboutTextView.delegate = self
        aboutTextView.isEditable = false

        versionLabel.text = L10n.version(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber)

        let attributedString = NSMutableAttributedString(string: L10n.aboutText)
        attributedString.setAsLink(textToFind: "https://swdestinydb.com", linkURL: "https://swdestinydb.com")

        aboutTextView.attributedText = attributedString
    }

    // MARK: - <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        didTouchHTTPLink?(url)
        return false
    }
}
