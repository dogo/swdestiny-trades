//
//  SnapshotTestCase.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import iOSSnapshotTestCase

// Enum para representar diferentes modos de teste
enum SnapshotTestMode {
    case record
    case test
}

class SnapshotTestCase: FBSnapshotTestCase {

    var referenceImageDirectory: String?
    var imageDiffDirectory: String?

    func verifyView(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        let directory = ("\(file)" as NSString).deletingLastPathComponent

        referenceImageDirectory = NSString.path(withComponents: [directory, "ReferenceImages"])
        imageDiffDirectory = NSString.path(withComponents: [directory, "FailureDiffs"])

        FBSnapshotVerifyView(view, identifier: nil, perPixelTolerance: 0, overallTolerance: 0, file: file, line: line)
    }

    func verifyViewController(_ viewController: UIViewController, file: StaticString = #file, line: UInt = #line) {
        let directory = ("\(file)" as NSString).deletingLastPathComponent

        referenceImageDirectory = NSString.path(withComponents: [directory, "ReferenceImages"])
        imageDiffDirectory = NSString.path(withComponents: [directory, "FailureDiffs"])

        FBSnapshotVerifyViewController(viewController, identifier: nil, perPixelTolerance: 0, overallTolerance: 0, file: file, line: line)
    }

    override func getReferenceImageDirectory(withDefault dir: String?) -> String {
        guard let referenceImageDirectory = referenceImageDirectory else {
            fatalError("Do not call FBSnapshotVerifyView or FBSnapshotVerifyViewController directly, use verifyView or verifyViewController instead.")
        }
        return referenceImageDirectory
    }

    override func getImageDiffDirectory(withDefault dir: String?) -> String {
        guard let imageDiffDirectory = imageDiffDirectory else {
            fatalError("Do not call FBSnapshotVerifyView or FBSnapshotVerifyViewController directly, use verifyView or verifyViewController instead.")
        }
        return imageDiffDirectory
    }
}
