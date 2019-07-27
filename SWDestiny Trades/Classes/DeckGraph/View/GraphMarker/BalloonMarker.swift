//
//  BalloonMarker.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Charts

open class BalloonMarker: MarkerImage {
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()

    private var labelns: NSString?
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
        var offset = self.offset

        let chart = self.chartView

        var size = self.size

        if size.width == 0.0 && image != nil {
            size.width = image?.size.width ?? 0.0
        }
        if size.height == 0.0 && image != nil {
            size.height = image?.size.height ?? 0.0
        }

        let width = size.width
        let height = size.height
        let padding = CGFloat(8.0)
        var origin = point
        origin.x -= width / 2
        origin.y -= height
        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if let chart = chart, origin.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0 {
            offset.y = height + padding
        } else if let chart = chart, origin.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }

    override open func draw(context: CGContext, point: CGPoint) {
        if labelns == nil {
            return
        }
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        context.saveGState()

        if let color = color {
            context.setFillColor(color.cgColor)
            if offset.y > 0 {
                context.beginPath()
                context.move(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                    y: rect.origin.y + arrowSize.height))
                //arrow vertex
                context.addLine(to: CGPoint(
                    x: point.x,
                    y: point.y))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                    y: rect.origin.y + arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y + arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y + rect.size.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + rect.size.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + arrowSize.height))
                context.fillPath()
            } else {
                context.beginPath()
                context.move(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y + rect.size.height - arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                    y: rect.origin.y + rect.size.height - arrowSize.height))
                //arrow vertex
                context.addLine(to: CGPoint(
                    x: point.x,
                    y: point.y))
                context.addLine(to: CGPoint(
                    x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                    y: rect.origin.y + rect.size.height - arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + rect.size.height - arrowSize.height))
                context.addLine(to: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y))
                context.fillPath()
            }
        }
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }
        rect.size.height -= self.insets.top + self.insets.bottom

        UIGraphicsPushContext(context)

        labelns?.draw(in: rect, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(String(entry.y))
    }

    open func setLabel(_ label: String) {
        labelns = label as NSString

        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedString.Key.font] = self.font
        _drawAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedString.Key.foregroundColor] = self.textColor

        _labelSize = labelns?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
