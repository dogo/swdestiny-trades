//
//  BalloonMarkerView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 29/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import DGCharts
import Foundation
import UIKit

final class BalloonMarkerView: BalloonMarker {

    private let formattingClosure: (Int) -> String

    init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, formattingClosure: @escaping (Int) -> String) {
        self.formattingClosure = formattingClosure
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let formattedText = formattingClosure(Int(round(entry.y)))
        setLabel(formattedText)
    }
}
