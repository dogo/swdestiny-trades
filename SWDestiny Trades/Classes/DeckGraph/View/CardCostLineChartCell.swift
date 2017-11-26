//
//  CardCostLineCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 27/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable
import Charts

final class CardCostLineChartCell: UICollectionViewCell, Reusable, BaseViewConfiguration {

    var cardCostChartView: LineChartView = {
        let view = LineChartView(frame: .zero)
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
        setDataCount(dataValues: dataValues)
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(cardCostChartView)
    }

    internal func setupConstraints() {
        cardCostChartView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }

    internal func configureViews() {
        setupLineChartView(chartView: cardCostChartView)
    }

    // MARK: - Setup

    func setDataCount(dataValues: [Int]) {
        if dataValues.count > 0 {
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<dataValues.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(dataValues[i]))
                dataEntries.append(dataEntry)
            }

            let chartDataSet = LineChartDataSet(values: dataEntries, label: L10n.cardCost)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.setColor(.lightGray)
            chartDataSet.setCircleColor(.lightGray)
            chartDataSet.drawCircleHoleEnabled = false
            let chartData = LineChartData(dataSet: chartDataSet)
            cardCostChartView.data = chartData
        }
    }

    func setupLineChartView(chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false

        let xAxis: XAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(10.0))
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0

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
                                  xAxisValueFormatter: cardCostChartView.xAxis.valueFormatter!)
        marker.chartView = cardCostChartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
    }
}
