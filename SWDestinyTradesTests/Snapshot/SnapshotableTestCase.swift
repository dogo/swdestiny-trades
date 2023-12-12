//
//  SnapshotableTestCase.swift
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

class SnapshotableTestCase: FBSnapshotTestCase {

    func snapshot(_ viewOrLayer: AnyObject,
                  named: String? = nil,
                  testMode: SnapshotTestMode = .test,
                  perPixelTolerance: CGFloat = 0,
                  overallTolerance: CGFloat = 0,
                  file: StaticString = #file) -> Bool {
        if viewOrLayer.isKind(of: UIView.self), let view = viewOrLayer as? UIView {
            return verifySnapshot(view,
                                  snapshotName: named,
                                  testMode: testMode,
                                  perPixelTolerance: perPixelTolerance,
                                  overallTolerance: overallTolerance,
                                  file: file)
        } else if viewOrLayer.isKind(of: UIViewController.self), let viewController = viewOrLayer as? UIViewController {
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            return verifySnapshot(viewController.view,
                                  snapshotName: named,
                                  testMode: testMode,
                                  perPixelTolerance: perPixelTolerance,
                                  overallTolerance: overallTolerance,
                                  file: file)
        } else {
            assertionFailure("Only UIView and CALayer classes can be snapshotted")
            return false
        }
    }

    // swiftlint:disable:next function_parameter_count
    private func verifySnapshot(_ viewOrLayer: AnyObject,
                                snapshotName: String?,
                                testMode: SnapshotTestMode,
                                perPixelTolerance: CGFloat,
                                overallTolerance: CGFloat,
                                file: StaticString) -> Bool {
        let sanitizedName = sanitizedTestName(snapshotName)
        return FBSnapshotTestCase.validateSnapshot(viewOrLayer,
                                                   snapshot: sanitizedName,
                                                   record: testMode == .record,
                                                   referenceDirectory: getDefaultReferenceDirectory(file),
                                                   imageDiffDirectory: getDefaultDiffDirectory(file),
                                                   perPixelTolerance: perPixelTolerance,
                                                   overallTolerance: overallTolerance,
                                                   filename: file)
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
        let fileName = String(describing: sourceFileName)

        // Find the directory in the path that ends with a test or specs suffix.
        guard let testPath = fileName.components(separatedBy: "/").first(where: { component in
            ["tests", "specs"].contains {
                component.lowercased().hasSuffix($0)
            }
        }) else {
            fatalError("Could not infer the unit test root folder")
        }

        // Recombine the path components and append our own image directory.
        guard let currentIndex = fileName.components(separatedBy: "/").firstIndex(of: testPath) else {
            fatalError("Unexpected error while extracting the test path.")
        }

        let folderPathComponents = Array(fileName.components(separatedBy: "/")[0 ... currentIndex])
        let folderPath = folderPathComponents.joined(separator: "/")

        return folderPath
    }

    private func sanitizedTestName(_ snapshotName: String?) -> String {
        var filename = snapshotName ?? name
        filename = filename.replacingOccurrences(of: "root example group, ", with: "")
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        let components = filename.components(separatedBy: characterSet.inverted)
        return components.joined(separator: "_")
    }
}
