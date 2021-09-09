//
//  RadarMarkerView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 29/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Charts
import Foundation
import UIKit

final class RadarMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter?
    private var yFormatter = NumberFormatter()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: IAxisValueFormatter) {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }

    override public func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(L10n.sidesCount(Int(round(entry.y))))
    }
}
