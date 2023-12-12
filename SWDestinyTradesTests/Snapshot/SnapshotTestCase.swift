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

    func verifySnapshot(_ viewOrLayer: AnyObject,
                        perPixelTolerance: CGFloat = 0,
                        overallTolerance: CGFloat = 0,
                        file: StaticString = #file,
                        line: UInt = #line) {
        referenceImageDirectory = getDefaultReferenceDirectory(file)
        imageDiffDirectory = getDefaultDiffDirectory(file)

        if viewOrLayer.isKind(of: UIView.self), let view = viewOrLayer as? UIView {
            FBSnapshotVerifyView(view,
                                 identifier: nil,
                                 suffixes: NSOrderedSet(object: "Images"),
                                 perPixelTolerance: perPixelTolerance,
                                 overallTolerance: overallTolerance,
                                 file: file,
                                 line: line)
        } else if viewOrLayer.isKind(of: UIViewController.self), let viewController = viewOrLayer as? UIViewController {
            FBSnapshotVerifyViewController(viewController,
                                           identifier: nil,
                                           suffixes: NSOrderedSet(object: "Images"),
                                           perPixelTolerance: perPixelTolerance,
                                           overallTolerance: overallTolerance,
                                           file: file,
                                           line: line)
        } else {
            assertionFailure("Only UIView and CALayer classes can be snapshotted")
        }
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

        return getTestsRootFolder(sourceFileName) + "/Reference"
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
        // Convert StaticString to String
        let fileName = String(describing: sourceFileName)

        // Find the directory in the path that ends with a test suffix.
        guard let testPath = fileName.components(separatedBy: "/").first(where: { component in
            ["tests", "specs"].contains {
                component.lowercased().hasSuffix($0)
            }
        }) else {
            fatalError("Could not infer reference image folder – You should provide a reference dir using " +
                "FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR) " +
                "or by setting the FB_REFERENCE_IMAGE_DIR environment variable")
        }

        // Recombine the path components and append our own image directory.
        guard let currentIndex = fileName.components(separatedBy: "/").firstIndex(of: testPath) else {
            fatalError("Unexpected error while extracting the test path.")
        }

        let folderPathComponents = Array(fileName.components(separatedBy: "/")[0 ... currentIndex])
        let folderPath = folderPathComponents.joined(separator: "/")

        return folderPath
    }
}
