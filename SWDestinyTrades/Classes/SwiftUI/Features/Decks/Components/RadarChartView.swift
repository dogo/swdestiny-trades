//
//  RadarChartView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SwiftUIRadarChartView: View {
    let data: [Int]
    let labels: [String]
    let title: String

    @State private var selectedIndex: Int?

    private let webColor = Color(.systemGray)
    private let fillColor = ColorPalette.accent
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
        HStack(spacing: 6.0) {
            RoundedRectangle(cornerRadius: 2.0)
                .fill(fillColor)
                .frame(width: 8.0, height: 8.0)
            Text(title)
                .font(.caption)
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Drawing

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        guard !data.isEmpty, data.count == labels.count else { return }

        let count = data.count
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = max(min(size.width, size.height) / 2.0 - labelInset, 0.0)
        let maxValue = Double(max(data.max() ?? 0, 1))
        let ringCount = max(min(data.max() ?? 1, 10), 1)

        drawWeb(in: &context, center: center, radius: radius, count: count, ringCount: ringCount)
        drawSpokes(in: &context, center: center, radius: radius, count: count)
        drawDataPolygon(in: &context, center: center, radius: radius, count: count, maxValue: maxValue)
        drawLabels(in: &context, center: center, radius: radius, count: count)

        if let selectedIndex, data.indices.contains(selectedIndex) {
            let fraction = Double(data[selectedIndex]) / maxValue
            let vertex = point(center: center, radius: radius, index: selectedIndex, fraction: fraction, count: count)
            drawHighlight(in: &context, at: vertex)
            drawBalloon(in: &context, at: vertex, size: size, text: L10n.sidesCount(data[selectedIndex]))
        }
    }

    private func drawWeb(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int, ringCount: Int) {
        for ring in 1...ringCount {
            let fraction = Double(ring) / Double(ringCount)
            var path = Path()
            for index in 0..<count {
                let vertex = point(center: center, radius: radius, index: index, fraction: fraction, count: count)
                index == 0 ? path.move(to: vertex) : path.addLine(to: vertex)
            }
            path.closeSubpath()
            context.stroke(path, with: .color(webColor.opacity(0.5)), lineWidth: 1.0)
        }
    }

    private func drawSpokes(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int) {
        for index in 0..<count {
            let vertex = point(center: center, radius: radius, index: index, fraction: 1.0, count: count)
            var path = Path()
            path.move(to: center)
            path.addLine(to: vertex)
            context.stroke(path, with: .color(webColor.opacity(0.5)), lineWidth: 1.0)
        }
    }

    private func drawDataPolygon(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int, maxValue: Double) {
        var path = Path()
        for index in 0..<count {
            let fraction = Double(data[index]) / maxValue
            let vertex = point(center: center, radius: radius, index: index, fraction: fraction, count: count)
            index == 0 ? path.move(to: vertex) : path.addLine(to: vertex)
        }
        path.closeSubpath()
        context.fill(path, with: .color(fillColor.opacity(0.7)))
        context.stroke(path, with: .color(fillColor), lineWidth: 2.0)
    }

    private func drawLabels(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int) {
        for index in 0..<count {
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
        context.fill(dot, with: .color(fillColor))
        context.stroke(dot, with: .color(.white), lineWidth: 1.0)
    }

    private func drawBalloon(in context: inout GraphicsContext, at point: CGPoint, size: CGSize, text: String) {
        let resolved = context.resolve(
            Text(text)
                .font(.system(size: 10.0))
                .foregroundStyle(.white)
        )
        let textSize = resolved.measure(in: size)
        let arrowHeight: CGFloat = 8.0
        let arrowWidth: CGFloat = 12.0
        let boxWidth = textSize.width + 16.0
        let boxHeight = textSize.height + 12.0

        let placeAbove = point.y - arrowHeight - boxHeight >= 0.0
        let boxY = placeAbove ? point.y - arrowHeight - boxHeight : point.y + arrowHeight
        let boxX = min(max(point.x - boxWidth / 2.0, 0.0), size.width - boxWidth)
        let boxRect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)

        context.fill(Path(roundedRect: boxRect, cornerRadius: 6.0), with: .color(webColor))

        let tipX = min(max(point.x, boxX + arrowWidth / 2.0), boxX + boxWidth - arrowWidth / 2.0)
        let baseY = placeAbove ? boxRect.maxY : boxRect.minY
        var arrow = Path()
        arrow.move(to: CGPoint(x: tipX - arrowWidth / 2.0, y: baseY))
        arrow.addLine(to: CGPoint(x: tipX + arrowWidth / 2.0, y: baseY))
        arrow.addLine(to: point)
        arrow.closeSubpath()
        context.fill(arrow, with: .color(webColor))

        context.draw(resolved, at: CGPoint(x: boxRect.midX, y: boxRect.midY), anchor: .center)
    }

    // MARK: - Interaction

    private func handleTap(at location: CGPoint, size: CGSize) {
        guard !data.isEmpty, data.count == labels.count else { return }

        let count = data.count
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = max(min(size.width, size.height) / 2.0 - labelInset, 0.0)
        let maxValue = Double(max(data.max() ?? 0, 1))

        var nearestIndex: Int?
        var nearestDistance = CGFloat.greatestFiniteMagnitude
        for index in 0..<count {
            let fraction = Double(data[index]) / maxValue
            let vertex = point(center: center, radius: radius, index: index, fraction: fraction, count: count)
            let distance = hypot(vertex.x - location.x, vertex.y - location.y)
            if distance < nearestDistance {
                nearestDistance = distance
                nearestIndex = index
            }
        }

        withAnimation(.easeInOut(duration: 0.15)) {
            if let nearestIndex, nearestDistance <= tapThreshold {
                selectedIndex = (selectedIndex == nearestIndex) ? nil : nearestIndex
            } else {
                selectedIndex = nil
            }
        }
    }

    // MARK: - Geometry

    private func angle(index: Int, count: Int) -> Double {
        -Double.pi / 2.0 + Double(index) * (2.0 * Double.pi / Double(count))
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
