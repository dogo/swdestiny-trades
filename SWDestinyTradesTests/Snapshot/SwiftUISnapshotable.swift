//
//  SwiftUISnapshotable.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

/// Controls the rendering size of a SwiftUI snapshot.
enum SnapshotSize {
    /// Full device screen bounds (default).
    case device
    /// Fixed custom size.
    case fixed(CGSize)
    /// Smallest size that fits the view's content.
    case intrinsic
}

extension XCSnapshotableTestCase {

    /// Captures and validates a snapshot of a SwiftUI view.
    ///
    /// Wraps the view in a `UIHostingController` and delegates to the existing
    /// `snapshot(_:named:testMode:perPixelTolerance:overallTolerance:file:)` method,
    /// so reference images are stored in the same directory as UIKit snapshots.
    ///
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot.
    ///   - size: The rendering size strategy. Defaults to `.device`.
    ///   - named: Optional snapshot name. Defaults to the test name.
    ///   - testMode: `.record` to save a new reference, `.validate` to compare. Defaults to `.validate`.
    ///   - perPixelTolerance: Per-channel pixel tolerance. Defaults to `0.02`.
    ///   - overallTolerance: Overall differing-pixel tolerance. Defaults to `0`.
    ///   - file: Source file path (auto-captured).
    /// - Returns: `true` if validation or recording succeeds.
    @discardableResult
    func snapshot(
        _ view: some View,
        size: SnapshotSize = .device,
        named: String? = nil,
        testMode: SnapshotTestMode = .validate,
        perPixelTolerance: CGFloat = 0.02,
        overallTolerance: CGFloat = 0,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {
        let controller = UIHostingController(rootView: view)
        controller.view.backgroundColor = .systemBackground

        let frame: CGRect
        switch size {
        case .device:
            frame = UIScreen.main.bounds
        case let .fixed(cgSize):
            frame = CGRect(origin: .zero, size: cgSize)
        case .intrinsic:
            let fitted = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            frame = CGRect(origin: .zero, size: fitted)
        }

        controller.view.frame = frame

        // Attach to a window so SwiftUI's render pass executes before capture.
        let window = UIWindow(frame: frame)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.view.layoutIfNeeded()
        RunLoop.main.run(until: Date())

        return snapshot(controller,
                        named: named,
                        testMode: testMode,
                        perPixelTolerance: perPixelTolerance,
                        overallTolerance: overallTolerance,
                        file: file,
                        line: line)
    }
}
