//
//  LineChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import DGCharts
import SwiftUI

struct SwiftUILineChartView: UIViewRepresentable {
    let data: [Int]
    let title: String

    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        setupLineChart(chartView)
        return chartView
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        setLineChartData(uiView)
    }

    private func setupLineChart(_ chartView: LineChartView) {
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
        xAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0

        // Y-Axis configuration
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        leftAxis.labelTextColor = UIColor.label
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 18
        leftAxis.granularity = 2.0

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

    private func setLineChartData(_ chartView: LineChartView) {
        guard !data.isEmpty else {
            chartView.data = nil
            return
        }

        var dataEntries: [ChartDataEntry] = []
        for (index, value) in data.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: Double(value))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = LineChartDataSet(entries: dataEntries, label: title)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.setColor(UIColor.systemBlue)
        chartDataSet.setCircleColor(UIColor.systemBlue)
        chartDataSet.drawCircleHoleEnabled = false

        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
}
