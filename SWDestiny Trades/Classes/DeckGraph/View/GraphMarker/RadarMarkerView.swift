//
//  RadarMarkerView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 29/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Charts

final class RadarMarkerView: BalloonMarker {

    open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: IAxisValueFormatter) {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(String.localizedStringWithFormat(NSLocalizedString("SIDES_COUNT", comment: ""), Int(round(entry.y))))
    }
}
