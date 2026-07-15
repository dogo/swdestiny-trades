//
//  BarChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Charts
import SwiftUI

struct SwiftUIBarChartView: View {
    let data: [Int]
    let labels: [String]
    let title: String

    @State private var selectedLabel: String?

    private var entries: [(label: String, value: Int)] {
        zip(labels, data).map { (label: $0, value: $1) }
    }

    var body: some View {
        Chart {
            ForEach(Array(entries.enumerated()), id: \.offset) { _, entry in
                BarMark(
                    x: .value("Type", entry.label),
                    y: .value("Count", entry.value)
                )
                .foregroundStyle(by: .value("Series", title))
                .opacity(entry.label == selectedLabel ? 0.55 : 1.0)
            }
        }
        .chartForegroundStyleScale([title: ColorPalette.accent])
        .chartYScale(domain: 0.0 ... 18.0)
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 3.0))
        }
        .chartXAxis {
            AxisMarks {
                AxisGridLine().foregroundStyle(.clear)
                AxisValueLabel()
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Canvas { context, size in
                    drawBalloon(in: &context, size: size, proxy: proxy, geometry: geometry)
                }
                .allowsHitTesting(false)

                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        handleTap(at: location, proxy: proxy, geometry: geometry)
                    }
            }
        }
    }

    private func drawBalloon(in context: inout GraphicsContext, size: CGSize, proxy: ChartProxy, geometry: GeometryProxy) {
        guard let selectedLabel,
              let entry = entries.first(where: { $0.label == selectedLabel }),
              let plotFrame = proxy.plotFrame,
              let xPosition = proxy.position(forX: selectedLabel),
              let yPosition = proxy.position(forY: entry.value) else { return }

        let origin = geometry[plotFrame].origin
        let point = CGPoint(x: origin.x + xPosition, y: origin.y + yPosition)
        ChartBalloon.draw(in: &context, at: point, size: size, text: L10n.cardsCount(entry.value))
    }

    private func handleTap(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        guard let plotFrame = proxy.plotFrame else { return }
        let xPosition = location.x - geometry[plotFrame].origin.x
        guard let label: String = proxy.value(atX: xPosition),
              entries.contains(where: { $0.label == label }) else {
            selectedLabel = nil
            return
        }
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedLabel = (selectedLabel == label) ? nil : label
        }
    }
}
