//
//  DiceRadarCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 27/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable
import Charts

final class DiceRadarChartCell: UICollectionViewCell, Reusable, BaseViewConfiguration, IAxisValueFormatter {

    let dieFaces = ["Special", "Blank", "Melee", "Ranged", "Focus", "Disrupt", "Shield", "Discard", "Resource", "Indirect"]

    var diceRadarView: RadarChartView = {
        let view = RadarChartView(frame: .zero)
        view.webLineWidth = 1.0
        view.innerWebLineWidth = 1.0
        view.webColor = UIColor.lightGray
        view.innerWebColor = UIColor.lightGray
        view.webAlpha = 1.0
        view.chartDescription?.enabled = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(dataValues: [Int]) {
        setDataCount(values: dataValues)
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(diceRadarView)
    }

    internal func setupConstraints() {
        diceRadarView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }

    internal func configureViews() {
        setupLineChartView(chartView: diceRadarView)
    }

    // MARK: - Setup

    func setDataCount(values: [Int]) {

        var dataEntries: [RadarChartDataEntry] = []
        for i in 0..<dieFaces.count {
            let dataEntry = RadarChartDataEntry(value: Double(values[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = RadarChartDataSet(values: dataEntries, label: L10n.diceSymbols)
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
        xAxis.xOffset = 0.0
        xAxis.yOffset = 0.0
        xAxis.valueFormatter = self

        let yAxis: YAxis = diceRadarView.yAxis
        yAxis.axisMinimum = 0.0
        yAxis.drawLabelsEnabled = false

        chartView.rotationEnabled = false

        let marker = RadarMarkerView(color: UIColor.lightGray,
                                     font: UIFont.systemFont(ofSize: CGFloat(10.0)),
                                     textColor: UIColor.white,
                                     insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                     xAxisValueFormatter: diceRadarView.xAxis.valueFormatter!)
        marker.chartView = diceRadarView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        diceRadarView.marker = marker
    }

    // MARK: - IAxisValueFormatter

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dieFaces[Int(value) % dieFaces.count]
    }
}
