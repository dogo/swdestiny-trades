//
//  BarChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import DGCharts
import SwiftUI

struct SwiftUIBarChartView: UIViewRepresentable {
    let data: [Int]
    let labels: [String]
    let title: String

    func makeUIView(context: Context) -> BarChartView {
        let chartView = BarChartView()
        setupBarChart(chartView)
        return chartView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        setBarChartData(uiView)
    }

    private func setupBarChart(_ chartView: BarChartView) {
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.legend.textColor = UIColor.label
        chartView.noDataTextColor = UIColor.label
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false

        // X-Axis configuration
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.label
        xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = labels.count
        xAxis.valueFormatter = BarChartAxisValueFormatter(labels: labels)

        // Y-Axis configuration
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 18
        leftAxis.granularity = 2.0
        leftAxis.labelTextColor = UIColor.label

        // Marker configuration
        let marker = BalloonMarkerView(
            color: UIColor.systemGray,
            font: UIFont.systemFont(ofSize: 10.0),
            textColor: UIColor.white,
            insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0)
        ) { count in
            return L10n.cardsCount(count)
        }
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
    }

    private func setBarChartData(_ chartView: BarChartView) {
        guard !data.isEmpty else {
            chartView.data = nil
            return
        }

        var dataEntries: [BarChartDataEntry] = []
        for (index, value) in data.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(value))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: title)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.setColor(UIColor.systemBlue)

        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
}

class BarChartAxisValueFormatter: NSObject, AxisValueFormatter {
    private let labels: [String]

    init(labels: [String]) {
        self.labels = labels
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        return index < labels.count ? labels[index] : ""
    }
}
