//
//  DiceRadarChartCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 27/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

import DGCharts

final class DiceRadarChartCell: UICollectionViewCell, Identifiable {
    let dieFaces = ["Special", "Blank", "Melee", "Ranged", "Focus",
                    "Disrupt", "Shield", "Discard", "Resource", "Indirect"]

    var diceRadarView: RadarChartView = {
        let view = RadarChartView(frame: .zero)
        view.webLineWidth = 1.0
        view.innerWebLineWidth = 1.0
        view.webColor = .lightGray
        view.innerWebColor = .lightGray
        view.webAlpha = 1.0
        view.chartDescription.enabled = false
        view.legend.textColor = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(dataValues: [Int]) {
        setDataCount(values: dataValues)
    }

    // MARK: - Setup

    func setDataCount(values: [Int]) {
        var dataEntries: [RadarChartDataEntry] = []
        for dieFace in 0 ..< dieFaces.count {
            let dataEntry = RadarChartDataEntry(value: Double(values[dieFace]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: L10n.diceSymbols)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 0.7
        chartDataSet.lineWidth = 2.0
        chartDataSet.drawHighlightCircleEnabled = true
        chartDataSet.setDrawHighlightIndicators(false)
        chartDataSet.setColor(.lightGray)
        chartDataSet.fillColor = .lightGray

        let chartData = RadarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        diceRadarView.data = chartData
    }

    func setupLineChartView(chartView: PieRadarChartViewBase) {
        let xAxis: XAxis = diceRadarView.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(12.0))
        xAxis.labelTextColor = .black
        xAxis.xOffset = 0.0
        xAxis.yOffset = 0.0
        xAxis.valueFormatter = self

        let yAxis: YAxis = diceRadarView.yAxis
        yAxis.axisMinimum = 0.0
        yAxis.drawLabelsEnabled = false
        yAxis.labelTextColor = .black

        chartView.rotationEnabled = false

        let marker = RadarMarkerView(color: .lightGray,
                                     font: UIFont.systemFont(ofSize: CGFloat(10.0)),
                                     textColor: .white,
                                     insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                     xAxisValueFormatter: self)
        marker.chartView = diceRadarView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        diceRadarView.marker = marker
    }
}

extension DiceRadarChartCell: AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dieFaces[Int(value) % dieFaces.count]
    }
}

extension DiceRadarChartCell: BaseViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(diceRadarView)
    }

    func setupConstraints() {
        diceRadarView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor)
        }
    }

    func configureViews() {
        setupLineChartView(chartView: diceRadarView)
    }
}
