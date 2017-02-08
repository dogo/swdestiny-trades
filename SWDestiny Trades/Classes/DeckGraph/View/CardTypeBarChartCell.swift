//
//  CardTypeBarChartCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 23/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable
import Charts

final class CardTypeBarChartCell: UICollectionViewCell, Reusable, BaseViewConfiguration, IAxisValueFormatter {

    let cardTypes = ["Upgrade", "Support", "Event"]

    var cardTypeChartView: BarChartView = {
        let view = BarChartView(frame: .zero)
        view.drawBarShadowEnabled = false
        view.drawValueAboveBarEnabled = true
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
        self.contentView.addSubview(cardTypeChartView)
    }

    internal func setupConstraints() {
        cardTypeChartView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }

    internal func configureViews() {
        setupBarLineChartView(chartView: cardTypeChartView)
    }

    // MARK: - Setup

    func setDataCount(values: [Int]) {
        if values.count > 0 {
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<cardTypes.count {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
                dataEntries.append(dataEntry)
            }

            let chartDataSet = BarChartDataSet(values: dataEntries, label: NSLocalizedString("CARD_TYPES", comment: ""))
            chartDataSet.drawValuesEnabled = false
            chartDataSet.setColor(.lightGray)
            let chartData = BarChartData(dataSet: chartDataSet)
            cardTypeChartView.data = chartData
        }
    }

    func setupBarLineChartView(chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false

        let xAxis: XAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(12.0))
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 3
        xAxis.valueFormatter = self

        let leftAxis: YAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(10.0))
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 18
        leftAxis.granularity = 2.0

        let marker = XYMarkerView(color: UIColor.lightGray,
                                  font: UIFont.systemFont(ofSize: CGFloat(10.0)),
                                  textColor: UIColor.white,
                                  insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
    }

    // MARK: - IAxisValueFormatter

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return cardTypes[Int(value)]
    }
}