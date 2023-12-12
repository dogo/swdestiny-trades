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

    // swiftlint:disable:next function_parameter_count
    static func validateSnapshot(_ instance: AnyObject,
                                 isDeviceAgnostic: Bool = false,
                                 usesDrawRect: Bool = false,
                                 snapshot: String,
                                 record: Bool,
                                 referenceDirectory: String,
                                 imageDiffDirectory: String,
                                 perPixelTolerance: CGFloat,
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
