//
//  RadarChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SwiftUIRadarChartView: View {
    let data: [[Int]]
    let labels: [String]
    let seriesNames: [String]

    @State private var selectedIndex: Int?

    private let webColor = Color(.systemGray)
    private let labelInset: CGFloat = 44.0
    private let tapThreshold: CGFloat = 40.0

    var body: some View {
        VStack(spacing: 8.0) {
            GeometryReader { geometry in
                Canvas { context, size in
                    draw(in: &context, size: size)
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    handleTap(at: location, size: geometry.size)
                }
            }

            legend
        }
    }

    private var legend: some View {
        ViewThatFits {
            HStack(spacing: 12.0) { legendItems }
            VStack(alignment: .leading, spacing: 4.0) { legendItems }
        }
    }

    private var legendItems: some View {
        ForEach(seriesNames.indices, id: \.self) { index in
            HStack(spacing: 6.0) {
                RoundedRectangle(cornerRadius: 2.0)
                    .fill(color(series: index))
                    .frame(width: 8.0, height: 8.0)
                Text(seriesNames[index])
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
    }

    private func color(series: Int) -> Color {
        ColorPalette.accent.mix(with: .black, by: Double(series) / 3.0)
    }

    // MARK: - Drawing

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        guard isValid else { return }

        let count = labels.count
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = max(min(size.width, size.height) / 2.0 - labelInset, 0.0)
        let maxValue = Double(max(largestValue, 1))
        let ringCount = max(min(largestValue, 10), 1)

        drawWeb(in: &context, center: center, radius: radius, ringCount: ringCount)
        drawSpokes(in: &context, center: center, radius: radius, count: count)
        for series in data.indices {
            drawDataPolygon(in: &context, series: series, center: center, radius: radius, maxValue: maxValue)
        }
        drawLabels(in: &context, center: center, radius: radius, count: count)

        if let selectedIndex, labels.indices.contains(selectedIndex) {
            let fraction = Double(data[0][selectedIndex]) / maxValue
            let vertex = point(center: center, radius: radius, index: selectedIndex, fraction: fraction, count: count)
            drawHighlight(in: &context, at: vertex)
            let text = data.indices.map { "\(seriesNames[$0]): \(data[$0][selectedIndex])" }.joined(separator: "\n")
            ChartBalloon.draw(in: &context, at: vertex, size: size, text: text)
        }
    }

    private func drawWeb(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, ringCount: Int) {
        for ring in 1 ... ringCount {
            let ringRadius = radius * Double(ring) / Double(ringCount)
            let circle = Path(ellipseIn: CGRect(x: center.x - ringRadius, y: center.y - ringRadius, width: ringRadius * 2.0, height: ringRadius * 2.0))
            context.stroke(circle, with: .color(webColor.opacity(0.5)), lineWidth: 1.0)
        }
    }

    private func drawSpokes(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int) {
        for index in 0 ..< count {
            let radians = angle(index: index, count: count) - Double.pi / Double(count)
            let vertex = CGPoint(x: center.x + radius * cos(radians), y: center.y + radius * sin(radians))
            var path = Path()
            path.move(to: center)
            path.addLine(to: vertex)
            context.stroke(path, with: .color(webColor.opacity(0.5)), lineWidth: 1.0)
        }
    }

    private func drawDataPolygon(in context: inout GraphicsContext, series: Int, center: CGPoint, radius: CGFloat, maxValue: Double) {
        let count = labels.count
        let fillColor = color(series: series)
        var path = Path()
        for index in 0 ..< count {
            let fraction = Double(data[series][index]) / maxValue
            let vertex = point(center: center, radius: radius, index: index, fraction: fraction, count: count)
            if index == 0 {
                path.move(to: vertex)
            } else {
                path.addLine(to: vertex)
            }
        }
        path.closeSubpath()
        context.fill(path, with: .color(fillColor.opacity(0.7)))
        context.stroke(path, with: .color(fillColor), lineWidth: 2.0)
    }

    private func drawLabels(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int) {
        for index in 0 ..< count {
            let radians = angle(index: index, count: count)
            let direction = CGPoint(x: cos(radians), y: sin(radians))
            let labelPoint = CGPoint(
                x: center.x + (radius + 10.0) * direction.x,
                y: center.y + (radius + 10.0) * direction.y
            )
            let anchor = UnitPoint(x: 0.5 - direction.x * 0.5, y: 0.5 - direction.y * 0.5)
            let text = Text(labels[index])
                .font(.system(size: 12.0))
                .foregroundStyle(.primary)
            context.draw(text, at: labelPoint, anchor: anchor)
        }
    }

    private func drawHighlight(in context: inout GraphicsContext, at vertex: CGPoint) {
        let dot = Path(ellipseIn: CGRect(x: vertex.x - 4.0, y: vertex.y - 4.0, width: 8.0, height: 8.0))
        context.fill(dot, with: .color(color(series: 0)))
        context.stroke(dot, with: .color(.white), lineWidth: 1.0)
    }

    // MARK: - Interaction

    private func handleTap(at location: CGPoint, size: CGSize) {
        guard isValid else { return }

        let count = labels.count
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = max(min(size.width, size.height) / 2.0 - labelInset, 0.0)
        let distance = hypot(location.x - center.x, location.y - center.y)
        let step = 2.0 * Double.pi / Double(count)
        let fromTop = atan2(location.y - center.y, location.x - center.x) + Double.pi / 2.0
        let tappedIndex = Int((fromTop + 2.0 * Double.pi).truncatingRemainder(dividingBy: 2.0 * Double.pi) / step) % count

        withAnimation(.easeInOut(duration: 0.15)) {
            if distance <= radius + tapThreshold {
                selectedIndex = (selectedIndex == tappedIndex) ? nil : tappedIndex
            } else {
                selectedIndex = nil
            }
        }
    }

    // MARK: - Geometry

    private var isValid: Bool {
        !labels.isEmpty && !data.isEmpty && data.count == seriesNames.count && data.allSatisfy { $0.count == labels.count }
    }

    private var largestValue: Int {
        data.flatMap(\.self).max() ?? 0
    }

    private func angle(index: Int, count: Int) -> Double {
        -Double.pi / 2.0 + (Double(index) + 0.5) * (2.0 * Double.pi / Double(count))
    }

    private func point(center: CGPoint, radius: CGFloat, index: Int, fraction: Double, count: Int) -> CGPoint {
        let radians = angle(index: index, count: count)
        let scaledRadius = radius * fraction
        return CGPoint(
            x: center.x + scaledRadius * cos(radians),
            y: center.y + scaledRadius * sin(radians)
        )
    }
}
