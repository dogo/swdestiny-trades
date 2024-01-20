//
//  RadarMarkerView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 29/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import DGCharts
import Foundation
import UIKit

final class RadarMarkerView: BalloonMarker {

    var xAxisValueFormatter: AxisValueFormatter?
    private var yFormatter = NumberFormatter()

    init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: AxisValueFormatter) {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(L10n.sidesCount(Int(round(entry.y))))
    }
}
