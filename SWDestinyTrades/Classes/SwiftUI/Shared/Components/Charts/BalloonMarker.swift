//
//  BalloonMarker.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import DGCharts
import Foundation
import UIKit

open class BalloonMarker: MarkerImage {
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()

    private(set) var labelns: NSString?
    private var _labelSize = CGSize()
    private var _paragraphStyle: NSMutableParagraphStyle?
    private var _drawAttributes = [NSAttributedString.Key: Any]()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        super.init()

        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }

    override open func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var drawingOffset = offset
        var markerSize = size

        if markerSize.width == 0.0, let image {
            markerSize.width = image.size.width
        }
        if markerSize.height == 0.0, let image {
            markerSize.height = image.size.height
        }

        let width = markerSize.width
        let height = markerSize.height
        let padding = CGFloat(8.0)
        let originX = point.x - width / 2
        let originY = point.y - height
        let chartBounds = chartView?.bounds

        if originX + drawingOffset.x < 0.0 {
            drawingOffset.x = -originX + padding
        } else if let chartWidth = chartBounds?.width, originX + width + drawingOffset.x > chartWidth {
            drawingOffset.x = chartWidth - originX - width - padding
        }

        if originY + drawingOffset.y < 0 {
            drawingOffset.y = height + padding
        } else if let chartHeight = chartBounds?.height, originY + height + drawingOffset.y > chartHeight {
            drawingOffset.y = chartHeight - originY - height - padding
        }

        return drawingOffset
    }

    override open func draw(context: CGContext, point: CGPoint) {
        if labelns == nil {
            return
        }

        let offset = offsetForDrawing(atPoint: point)
        let size = size
        var rect = calculateRect(atPoint: point, withOffset: offset, andSize: size)

        context.saveGState()

        if let color {
            drawBackground(context: context, point: point, rect: rect, offset: offset, color: color)
        }

        rect = adjustRectForInsets(rect, offset: offset)

        drawLabel(in: rect, withAttributes: _drawAttributes, context: context)

        context.restoreGState()
    }

    private func calculateRect(atPoint point: CGPoint, withOffset offset: CGPoint, andSize size: CGSize) -> CGRect {
        var rect = CGRect(origin: CGPoint(x: point.x + offset.x, y: point.y + offset.y), size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        return rect
    }

    private func drawBackground(context: CGContext, point: CGPoint, rect: CGRect, offset: CGPoint, color: UIColor) {
        context.setFillColor(color.cgColor)

        context.beginPath()
        if offset.y > 0 {
            drawUpwardArrow(context: context, point: point, rect: rect)
        } else {
            drawDownwardArrow(context: context, point: point, rect: rect)
        }
        context.fillPath()
    }

    private func drawUpwardArrow(context: CGContext, point: CGPoint, rect: CGRect) {
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y + arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
            y: rect.origin.y + arrowSize.height
        ))
        // arrow vertex
        context.addLine(to: CGPoint(
            x: point.x,
            y: point.y
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
            y: rect.origin.y + arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y + arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y + rect.size.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y + rect.size.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y + arrowSize.height
        ))
        context.fillPath()
    }

    private func drawDownwardArrow(context: CGContext, point: CGPoint, rect: CGRect) {
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y + rect.size.height - arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
            y: rect.origin.y + rect.size.height - arrowSize.height
        ))
        // arrow vertex
        context.addLine(to: CGPoint(
            x: point.x,
            y: point.y
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
            y: rect.origin.y + rect.size.height - arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y + rect.size.height - arrowSize.height
        ))
        context.addLine(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y
        ))
        context.fillPath()
    }

    private func adjustRectForInsets(_ rect: CGRect, offset: CGPoint) -> CGRect {
        var adjustedRect = rect
        if offset.y > 0 {
            adjustedRect.origin.y += insets.top + arrowSize.height
        } else {
            adjustedRect.origin.y += insets.top
        }
        adjustedRect.size.height -= insets.top + insets.bottom
        return adjustedRect
    }

    private func drawLabel(in rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any], context: CGContext) {
        UIGraphicsPushContext(context)
        labelns?.draw(in: rect, withAttributes: attributes)
        UIGraphicsPopContext()
    }

    override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(String(entry.y))
    }

    open func setLabel(_ label: String) {
        labelns = label as NSString

        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedString.Key.font] = font
        _drawAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedString.Key.foregroundColor] = textColor

        if let labelns {
            _labelSize = labelns.size(withAttributes: _drawAttributes)
        }

        var size = CGSize()
        size.width = _labelSize.width + insets.left + insets.right
        size.height = _labelSize.height + insets.top + insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
