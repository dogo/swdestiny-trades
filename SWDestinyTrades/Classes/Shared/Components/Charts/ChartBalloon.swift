//
//  ChartBalloon.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 24/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// Draws a marker balloon into a `Canvas` whose arrow always points at the
/// target data point, even when the box is clamped to stay inside the chart.
enum ChartBalloon {
    static func draw(
        in context: inout GraphicsContext,
        at point: CGPoint,
        size: CGSize,
        text: String,
        color: Color = Color(.systemGray)
    ) {
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
        let boxX = min(max(point.x - boxWidth / 2.0, 0.0), max(size.width - boxWidth, 0.0))
        let boxRect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)

        context.fill(Path(roundedRect: boxRect, cornerRadius: 6.0), with: .color(color))

        let tipX = min(max(point.x, boxX + arrowWidth / 2.0), boxX + boxWidth - arrowWidth / 2.0)
        let baseY = placeAbove ? boxRect.maxY : boxRect.minY
        var arrow = Path()
        arrow.move(to: CGPoint(x: tipX - arrowWidth / 2.0, y: baseY))
        arrow.addLine(to: CGPoint(x: tipX + arrowWidth / 2.0, y: baseY))
        arrow.addLine(to: point)
        arrow.closeSubpath()
        context.fill(arrow, with: .color(color))

        context.draw(resolved, at: CGPoint(x: boxRect.midX, y: boxRect.midY), anchor: .center)
    }
}
