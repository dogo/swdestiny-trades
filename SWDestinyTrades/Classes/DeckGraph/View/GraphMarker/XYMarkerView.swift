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

    override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(L10n.cardsCount(Int(round(entry.y))))
    }
}
