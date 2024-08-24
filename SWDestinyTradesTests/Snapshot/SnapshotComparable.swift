//
//  SnapshotComparable.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 12/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import iOSSnapshotTestCaseCore
import UIKit
import XCTest

@objc
protocol Snapshotable {
    var snapshotObject: UIView? { get }
}

extension UIViewController: Snapshotable {
    var snapshotObject: UIView? {
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
        return view
    }
}

extension UIView: Snapshotable {
    var snapshotObject: UIView? {
        return self
    }
}

public extension FBSnapshotTestCase {

    /// Validates a snapshot of the specified view or layer against a reference image.
    /// - Parameters:
    ///   - instance: The view or layer to snapshot.
    ///   - isDeviceAgnostic: A Boolean value indicating whether the snapshot should account for device-specific traits such as device model, OS version, screen size, and screen scale. The default is `false`.
    ///   - usesDrawRect: A Boolean value indicating whether to use the `draw(_:)` method to capture the snapshot. The default is `false`.
    ///   - snapshot: The name of the snapshot to validate.
    ///   - record: A Boolean value indicating whether to record a new reference image if no matching snapshot is found. If `false`, the method compares the snapshot against the existing reference image.
    ///   - referenceDirectory: The directory where reference images are stored.
    ///   - imageDiffDirectory: The directory where image differences are stored when the snapshot comparison fails.
    ///   - perPixelTolerance: The percentage by which a pixel's R, G, B, and A components can differ from the reference image and still be considered identical. The default is `0.02`.
    ///   - overallTolerance: The percentage of pixels that can differ from the reference image and still be considered identical.
    ///   - filename: The file path of the test, used to parse the test name.
    ///   - identifier: An optional identifier to distinguish between multiple snapshots of the same view or layer. The default is `nil`.
    ///   - shouldIgnoreScale: A Boolean value indicating whether to ignore screen scale differences when comparing snapshots. The default is `false`.
    /// - Returns: `true` if the snapshot validation succeeds; otherwise, `false`.
    // swiftlint:disable:next function_parameter_count
    static func validateSnapshot(_ instance: AnyObject,
                                 isDeviceAgnostic: Bool = false,
                                 usesDrawRect: Bool = false,
                                 snapshot: String,
                                 record: Bool,
                                 referenceDirectory: String,
                                 imageDiffDirectory: String,
                                 perPixelTolerance: CGFloat = 0.02,
                                 overallTolerance: CGFloat,
                                 filename: StaticString,
                                 identifier: String? = nil,
                                 shouldIgnoreScale: Bool = false) -> Bool {

        let testName = FBSnapshotTestCase.parseFilename(filename: filename)
        let snapshotController = FBSnapshotTestController(test: self)
        snapshotController.folderName = testName
        if isDeviceAgnostic {
            snapshotController.fileNameOptions = [.device, .OS, .screenSize, .screenScale]
        } else if shouldIgnoreScale {
            snapshotController.fileNameOptions = .none
        } else {
            snapshotController.fileNameOptions = .screenScale
        }
        snapshotController.recordMode = record
        snapshotController.referenceImagesDirectory = referenceDirectory
        snapshotController.imageDiffDirectory = imageDiffDirectory

        snapshotController.usesDrawViewHierarchyInRect = usesDrawRect

        do {
            try snapshotController.compareSnapshot(ofViewOrLayer: instance,
                                                   selector: Selector(snapshot),
                                                   identifier: identifier,
                                                   perPixelTolerance: perPixelTolerance,
                                                   overallTolerance: overallTolerance)
            let image = try snapshotController.referenceImage(for: Selector(snapshot), identifier: identifier)
            FBSnapshotTestCase.attach(image: image, named: "Reference_\(snapshot)")
        } catch {
            let info = (error as NSError).userInfo
            if let ref = info[FBReferenceImageKey] as? UIImage {
                FBSnapshotTestCase.attach(image: ref, named: "Reference_\(snapshot)")
            }
            if let captured = info[FBCapturedImageKey] as? UIImage {
                FBSnapshotTestCase.attach(image: captured, named: "Captured_\(snapshot)")
            }
            if let diff = info[FBDiffedImageKey] as? UIImage {
                FBSnapshotTestCase.attach(image: diff, named: "Diffed_\(snapshot)")
            }
            return false
        }
        return true
    }

    private static func attach(image: UIImage, named name: String) {
        XCTContext.runActivity(named: name) { activity in
            let attachment = XCTAttachment(image: image)
            attachment.name = name
            activity.add(attachment)
        }
    }

    private static func parseFilename(filename: StaticString) -> String {
        let nsName = NSString(string: String(describing: filename))

        let type = ".\(nsName.pathExtension)"
        let sanitizedName = nsName.lastPathComponent.replacingOccurrences(of: type, with: "")

        return sanitizedName
    }
}
