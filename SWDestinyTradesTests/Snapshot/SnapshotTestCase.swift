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

    func verifyView(_ view: UIView,
                    perPixelTolerance: CGFloat = 0,
                    overallTolerance: CGFloat = 0,
                    file: StaticString = #file,
                    line: UInt = #line) {
        referenceImageDirectory = getDefaultReferenceDirectory(file)
        imageDiffDirectory = getDefaultDiffDirectory(file)

        FBSnapshotVerifyView(view,
                             identifier: nil,
                             suffixes: NSOrderedSet(),
                             perPixelTolerance: perPixelTolerance,
                             overallTolerance: overallTolerance,
                             file: file,
                             line: line)
    }

    func verifyViewController(_ viewController: UIViewController,
                              perPixelTolerance: CGFloat = 0,
                              overallTolerance: CGFloat = 0,
                              file: StaticString = #file,
                              line: UInt = #line) {
        referenceImageDirectory = getDefaultReferenceDirectory(file)
        imageDiffDirectory = getDefaultDiffDirectory(file)

        FBSnapshotVerifyViewController(viewController,
                                       identifier: nil,
                                       perPixelTolerance: 0,
                                       overallTolerance: 0,
                                       file: file,
                                       line: line)
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

    private func getDefaultReferenceDirectory(_ sourceFileName: StaticString) -> String {
        if let environmentReference = ProcessInfo.processInfo.environment["FB_REFERENCE_IMAGE_DIR"] {
            return environmentReference
        }

        return getTestsRootFolder(sourceFileName) + "/ReferenceImages"
    }

    private func getDefaultDiffDirectory(_ sourceFileName: StaticString) -> String {
        if let environmentReference = ProcessInfo.processInfo.environment["IMAGE_DIFF_DIR"] {
            return environmentReference
        }
        return getTestsRootFolder(sourceFileName) + "/FailureDiffs"
    }

    // Search the test file's path to find the first folder with a test suffix,
    // then append "/ReferenceImages" or "FailureDiffs" and use that.
    private func getTestsRootFolder(_ sourceFileName: StaticString) -> String {
        // Grab the file's path
        let fileName = NSString(string: "\(sourceFileName)")
        let pathComponents = fileName.pathComponents as NSArray

        // Find the directory in the path that ends with a test suffix.
        let testPath = pathComponents.first { component -> Bool in
            ["tests", "specs"].contains {
                (component as AnyObject).lowercased.hasSuffix($0)
            }
        }

        guard let testDirectory = testPath else {
            fatalError("Could not infer reference image folder – You should provide a reference dir using " +
                "FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR) " +
                "or by setting the FB_REFERENCE_IMAGE_DIR environment variable")
        }

        // Recombine the path components and append our own image directory.
        let currentIndex = pathComponents.index(of: testDirectory) + 1
        let folderPathComponents = pathComponents.subarray(with: NSRange(location: 0, length: currentIndex)) as NSArray
        let folderPath = folderPathComponents.componentsJoined(by: "/")

        return folderPath
    }
}
