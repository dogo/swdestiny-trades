//
//  SwdShareProvider.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class SwdShareProvider: UIActivityItemProvider {

    var subject: String
    var text: String

    init(subject: String = "", text: String) {
        self.subject = subject
        self.text = text

        super.init(placeholderItem: "")
    }

    override func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return subject
    }

    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        if activityType.rawValue.contains("whatsapp") {
            return self.text.replacingOccurrences(of: "\n", with: "</br>")
        }
        return text
    }
}
