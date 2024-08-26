//
//  FloatingTextfield.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 21/01/15.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import UIKit

final class FloatingTextfield: UITextField {

    // MARK: - Properties

    private let notificationCenter: NotificationCenterProtocol

    var underlineWidth: CGFloat = 2.0
    var underlineColor: UIColor = .black
    var underlineAlphaBefore: CGFloat = 0.5
    var underlineAlphaAfter: CGFloat = 1

    var placeholderTextColor: UIColor = .gray
    var animationDuration: TimeInterval = 0.35

    let scaleCoeff: CGFloat = 0.75
    let textInsetX: CGFloat = 1.5
    let placeholderAlphaAfter: CGFloat = 0.85
    let placeholderAlphaBefore: CGFloat = 0.5

    var placeholderLabel = UILabel(frame: CGRect.zero)
    var placeholderLabelMinCenter: CGFloat = 0.0
    var underlineView = UIView(frame: CGRect.zero)
    var isLifted = false

    // MARK: - Life Cycle

    init(frame: CGRect, notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        super.init(frame: frame)
        setupObserver()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawUnderline()
    }

    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)

        guard let font else { return }

        let placeholderRect = CGRect(x: rect.origin.x,
                                     y: underlineWidth,
                                     width: rect.size.width,
                                     height: font.pointSize)
        placeholderLabel = UILabel(frame: placeholderRect)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x,
                                          y: frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2)
        placeholderLabel.text = placeholder
        placeholder = nil

        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)

        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaBefore

        placeholderLabelMinCenter = placeholderLabel.center.x * scaleCoeff

        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }

    func drawPlaceholderIfTextExistInRect(rect: CGRect) {
        guard let font else { return }

        let placeholderRect = CGRect(x: rect.origin.x,
                                     y: underlineWidth * 2,
                                     width: rect.size.width,
                                     height: font.pointSize)
        placeholderLabel = UILabel(frame: placeholderRect)
        placeholderLabel.transform = CGAffineTransform(scaleX: scaleCoeff, y: scaleCoeff)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x * scaleCoeff,
                                          y: placeholderLabel.frame.size.height)
        placeholderLabel.text = placeholder
        placeholder = nil

        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)

        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaAfter
        isLifted = true

        placeholderLabelMinCenter = placeholderLabel.center.x

        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)

        if placeholder != nil, let textString = text, !textString.isEmpty {
            drawPlaceholderIfTextExistInRect(rect: rect)
        }

        textAlignment = .left
        contentVerticalAlignment = .bottom
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = underlineWidth + 2.0
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = underlineWidth + 2.0
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }

    // MARK: - Notification actions

    @objc
    func didBeginChangeText() {
        if !isLifted {
            liftUpPlaceholder()
        } else {
            animateUnderline(withAlpha: underlineAlphaAfter)
        }
    }

    @objc
    func didChangeText() {
        if isLifted {
            liftDownPlaceholderIfTextIsEmpty()
        } else {
            if let text, !text.isEmpty {
                liftUpPlaceholder()
            } else {
                animateUnderline(withAlpha: underlineAlphaBefore)
            }
        }
    }

    @objc
    func didEndChangingText() {
        liftDownPlaceholderIfTextIsEmpty()
    }

    // MARK: - Private

    private func drawUnderline() {
        let underLine = UIView(frame: CGRect(x: 0, y: frame.size.height - underlineWidth, width: frame.size.width, height: underlineWidth))

        underLine.backgroundColor = underlineColor
        underLine.alpha = underlineAlphaBefore

        underlineView = underLine
        addSubview(underlineView)
    }

    // MARK: LiftUp/LiftDown

    private func liftUpPlaceholder() {
        let newCenterX = max(placeholderLabelMinCenter, placeholderLabel.center.x * scaleCoeff)
        let newCenter = CGPoint(x: newCenterX,
                                y: placeholderLabel.frame.size.height)
        animatePlaceholder(withNewCenter: newCenter,
                           scaleCoeff: scaleCoeff,
                           newAlpha: placeholderAlphaAfter,
                           underlineAlpha: underlineAlphaAfter,
                           isLiftedAfterFinishing: true)
    }

    private func liftDownPlaceholderIfTextIsEmpty() {
        if let text, text.isEmpty {
            let newCenterX = min(placeholderLabelMinCenter / scaleCoeff, placeholderLabel.center.x / scaleCoeff)
            let newCenterY = frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2.0 - 2.0
            let newCenter = CGPoint(x: newCenterX, y: newCenterY)

            animatePlaceholder(withNewCenter: newCenter,
                               scaleCoeff: 1,
                               newAlpha: placeholderAlphaBefore,
                               underlineAlpha: underlineAlphaBefore,
                               isLiftedAfterFinishing: false)
        }
    }

    // MARK: - Animations

    private func animateUnderline(withAlpha alpha: CGFloat) {
        if animationDuration > 0 {
            UIView.animate(withDuration: animationDuration) {
                self.underlineView.alpha = alpha
            }
        } else {
            underlineView.alpha = alpha
        }
    }

    private func animatePlaceholder(withNewCenter newCenter: CGPoint,
                                    scaleCoeff: CGFloat,
                                    newAlpha: CGFloat,
                                    underlineAlpha: CGFloat,
                                    isLiftedAfterFinishing: Bool) {
        if animationDuration > 0 {
            UIView.animate(withDuration: animationDuration,
                           animations: {
                               self.placeholderLabel.transform(withCoeff: scaleCoeff, andMoveCenterToPoint: newCenter)
                               self.placeholderLabel.alpha = newAlpha
                               self.underlineView.alpha = underlineAlpha
                           }, completion: isLiftedCompletion(withNewValue: isLiftedAfterFinishing))
        } else {
            placeholderLabel.transform(withCoeff: scaleCoeff, andMoveCenterToPoint: newCenter)
            placeholderLabel.alpha = newAlpha
            underlineView.alpha = underlineAlpha
            isLiftedCompletion(withNewValue: isLiftedAfterFinishing)?(true)
        }
    }

    private func isLiftedCompletion(withNewValue value: Bool) -> ((Bool) -> Void)? {
        return { finished in
            if finished {
                self.isLifted = value
            }
        }
    }

    // MARK: - Notification

    private func setupObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(didBeginChangeText),
                                       name: UITextField.textDidBeginEditingNotification,
                                       object: self)
        notificationCenter.addObserver(self,
                                       selector: #selector(didChangeText),
                                       name: UITextField.textDidChangeNotification,
                                       object: self)
        notificationCenter.addObserver(self,
                                       selector: #selector(didEndChangingText),
                                       name: UITextField.textDidEndEditingNotification,
                                       object: self)
    }

    // MARK: - deinit

    deinit {
        notificationCenter.removeObserver(self)
    }
}

// MARK: - UIView Extension

private extension UIView {
    func transform(withCoeff coeff: CGFloat, andMoveCenterToPoint center: CGPoint) {
        let transform = CGAffineTransform(scaleX: coeff, y: coeff)
        self.transform = transform
        self.center = center
    }
}
