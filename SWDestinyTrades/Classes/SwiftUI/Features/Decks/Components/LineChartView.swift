//
//  LineChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Charts
import SwiftUI

struct SwiftUILineChartView: View {
    let data: [Int]
    let title: String

    @State private var selectedIndex: Int?

    var body: some View {
        Chart {
            if let selectedIndex, data.indices.contains(selectedIndex) {
                RuleMark(x: .value("Index", selectedIndex))
                    .foregroundStyle(Color(.systemYellow).opacity(0.8))
                    .lineStyle(StrokeStyle(lineWidth: 1.0))
                RuleMark(y: .value("Count", data[selectedIndex]))
                    .foregroundStyle(Color(.systemYellow).opacity(0.8))
                    .lineStyle(StrokeStyle(lineWidth: 1.0))
            }

            ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Count", value)
                )
                .foregroundStyle(by: .value("Series", title))
                .symbol {
                    Circle()
                        .fill(ColorPalette.accent)
                        .opacity(index == selectedIndex ? 0.5 : 1.0)
                        .frame(width: 7.0, height: 7.0)
                }
            }

            if let selectedIndex, data.indices.contains(selectedIndex) {
                PointMark(
                    x: .value("Index", selectedIndex),
                    y: .value("Count", data[selectedIndex])
                )
                .symbolSize(0.0)
                .foregroundStyle(.clear)
                .annotation(
                    position: .top,
                    spacing: 0.0,
                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)
                ) {
                    BalloonAnnotationView(text: L10n.cardsCount(data[selectedIndex]))
                }
            }
        }
        .chartForegroundStyleScale([title: ColorPalette.accent])
        .chartYScale(domain: 0.0...18.0)
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 3.0))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) {
                AxisGridLine().foregroundStyle(.clear)
                AxisValueLabel()
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        handleTap(at: location, proxy: proxy, geometry: geometry)
                    }
            }
        }
    }

    private func handleTap(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        guard let plotFrame = proxy.plotFrame else { return }
        let xPosition = location.x - geometry[plotFrame].origin.x
        guard let index: Int = proxy.value(atX: xPosition), data.indices.contains(index) else {
            selectedIndex = nil
            return
        }
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedIndex = (selectedIndex == index) ? nil : index
        }
    }
}
