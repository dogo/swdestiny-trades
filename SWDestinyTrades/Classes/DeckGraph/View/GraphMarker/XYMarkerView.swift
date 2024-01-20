//
//  XYMarkerView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import DGCharts
import Foundation
import UIKit

open class XYMarkerView: BalloonMarker {

    open var xAxisValueFormatter: AxisValueFormatter?
    private var yFormatter = NumberFormatter()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: AxisValueFormatter) {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }

    override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(L10n.cardsCount(Int(round(entry.y))))
    }
}
