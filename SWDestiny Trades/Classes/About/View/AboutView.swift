//
//  AboutView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AboutView: UIView, BaseViewConfiguration, UITextViewDelegate {

    var logoImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
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

    // MARK: <BaseViewConfiguration>

    func buildViewHierarchy() {
        self.addSubview(logoImage)
        self.addSubview(aboutTextView)
    }

    func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self).offset(34+44+20)
            make.centerX.equalTo(self)
            make.width.equalTo(280)
            make.height.equalTo(150)
        }

        aboutTextView.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(22)
            make.left.equalTo(self).offset(34)
            make.bottom.equalTo(self).offset(-34)
            make.right.equalTo(self).offset(-34)
        }
    }

    func configureViews() {

        self.backgroundColor = UIColor.white

        logoImage.image = UIImage(named: "LargeIconBlack")
        logoImage.contentMode = .scaleAspectFill

        aboutTextView.delegate = self
        aboutTextView.isEditable = false

        let attributedString = NSMutableAttributedString(string: "By Diogo Autilio\n\nAPI Data by Paco http://swdestinydb.com\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.")
        attributedString.setAsLink(textToFind: "http://swdestinydb.com", linkURL: "http://swdestinydb.com")

        aboutTextView.attributedText = attributedString
    }

    // MARK : <UITextViewDelegate>

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.openURL(URL)
        return false
    }
}
