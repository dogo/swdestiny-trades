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

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(L10n.sidesCount(Int(round(entry.y))))
    }
}
