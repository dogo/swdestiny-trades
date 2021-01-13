//
//  CardCostLineCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 27/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

import Charts

final class CardCostLineChartCell: UICollectionViewCell, Identifiable {
    let cardCostChartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.legend.textColor = .black
        view.noDataTextColor = .black
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

    internal func configureCell(dataValues: [Int]) {
        setDataCount(dataValues: dataValues)
    }

    // MARK: - Setup

    func setDataCount(dataValues: [Int]) {
        if !dataValues.isEmpty {
            var dataEntries: [ChartDataEntry] = []
            for value in 0 ..< dataValues.count {
                let dataEntry = ChartDataEntry(x: Double(value), y: Double(dataValues[value]))
                dataEntries.append(dataEntry)
            }

            let chartDataSet = LineChartDataSet(entries: dataEntries, label: L10n.cardCost)
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
        xAxis.labelTextColor = .black
        xAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(10.0))
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0

        let leftAxis: YAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(10.0))
        leftAxis.labelTextColor = .black
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 18
        leftAxis.granularity = 2.0

        if let xAxisValueFormatter = cardCostChartView.xAxis.valueFormatter {
            let marker = XYMarkerView(color: .lightGray,
                                      font: UIFont.systemFont(ofSize: CGFloat(10.0)),
                                      textColor: .white,
                                      insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                      xAxisValueFormatter: xAxisValueFormatter)
            marker.chartView = cardCostChartView
            marker.minimumSize = CGSize(width: 80.0, height: 40.0)
            chartView.marker = marker
        }
    }
}

extension CardCostLineChartCell: BaseViewConfiguration {
    internal func buildViewHierarchy() {
        contentView.addSubview(cardCostChartView)
    }

    internal func setupConstraints() {
        cardCostChartView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.contentView.topAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor)
            view.trailingAnchor(equalTo: self.contentView.trailingAnchor)
            view.bottomAnchor(equalTo: self.contentView.bottomAnchor)
        }
    }

    internal func configureViews() {
        setupLineChartView(chartView: cardCostChartView)
    }
}
