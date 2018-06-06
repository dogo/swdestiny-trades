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
        image.contentMode = .scaleAspectFill
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
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

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
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.snp.topMargin).offset(34)
            make.centerX.equalTo(self)
            make.width.equalTo(280)
            make.height.equalTo(150)
        }

        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom)
            make.right.equalTo(self.snp.right).offset(-15)
        }

        aboutTextView.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(22)
            make.left.equalTo(self).offset(12)
            make.bottom.equalTo(self).offset(-34)
            make.right.equalTo(self).offset(-12)
        }
    }

    internal func configureViews() {

        self.backgroundColor = .white

        logoImage.image = Asset.Logo.largeIconBlack.image

        aboutTextView.delegate = self
        aboutTextView.isEditable = false

        versionLabel.text = L10n.version(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber)

        let attributedString = NSMutableAttributedString(string: L10n.aboutText)
        attributedString.setAsLink(textToFind: "http://swdestinydb.com", linkURL: "http://swdestinydb.com")

        aboutTextView.attributedText = attributedString
    }

    // MARK: - <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        didTouchHTTPLink?(URL)
        return false
    }
}
