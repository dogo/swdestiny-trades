//
//  RadarChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import DGCharts
import SwiftUI

struct SwiftUIRadarChartView: UIViewRepresentable {
    let data: [Int]
    let labels: [String]
    let title: String

    func makeUIView(context: Context) -> RadarChartView {
        let chartView = RadarChartView()
        setupRadarChart(chartView)
        return chartView
    }

    func updateUIView(_ uiView: RadarChartView, context: Context) {
        setRadarChartData(uiView)
    }

    private func setupRadarChart(_ chartView: RadarChartView) {
        chartView.webLineWidth = 1.0
        chartView.innerWebLineWidth = 1.0
        chartView.webColor = UIColor.systemGray
        chartView.innerWebColor = UIColor.systemGray
        chartView.webAlpha = 1.0
        chartView.chartDescription.enabled = false
        chartView.legend.textColor = UIColor.label
        chartView.rotationEnabled = false

        // X-Axis configuration
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        xAxis.labelTextColor = UIColor.label
        xAxis.xOffset = 0.0
        xAxis.yOffset = 0.0
        xAxis.valueFormatter = RadarChartAxisValueFormatter(labels: labels)

        // Y-Axis configuration
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0.0
        yAxis.drawLabelsEnabled = false
        yAxis.labelTextColor = UIColor.label

        // Marker configuration
        let marker = BalloonMarkerView(
            color: UIColor.systemGray,
            font: UIFont.systemFont(ofSize: 10.0),
            textColor: UIColor.white,
            insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0)
        ) { count in
            return L10n.sidesCount(count)
        }
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
    }

    private func setRadarChartData(_ chartView: RadarChartView) {
        guard !data.isEmpty else {
            chartView.data = nil
            return
        }

        var dataEntries: [RadarChartDataEntry] = []
        for value in data {
            let dataEntry = RadarChartDataEntry(value: Double(value))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: title)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 0.7
        chartDataSet.lineWidth = 2.0
        chartDataSet.drawHighlightCircleEnabled = true
        chartDataSet.setDrawHighlightIndicators(false)
        chartDataSet.setColor(UIColor.systemBlue)
        chartDataSet.fillColor = UIColor.systemBlue

        let chartData = RadarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartView.data = chartData
    }
}

class RadarChartAxisValueFormatter: NSObject, AxisValueFormatter {
    private let labels: [String]

    init(labels: [String]) {
        self.labels = labels
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value) % labels.count
        return index < labels.count ? labels[index] : ""
    }
}
