//
//  AboutViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var aboutText: UITextView!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutText.delegate = self
        let attributedString = NSMutableAttributedString(string: "By Diogo Autilio\n\nAPI Data by Paco http://swdestinydb.com\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.")
        attributedString.setAsLink(textToFind: "http://swdestinydb.com", linkURL: "http://swdestinydb.com")
        aboutText.attributedText = attributedString
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.openURL(URL)
        return false
    }

}
